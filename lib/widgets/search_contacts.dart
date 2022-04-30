import 'dart:async';

import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:contacts_service/contacts_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

class SearchContacts extends StatefulWidget {
  SearchContacts({Key? key}) : super(key: key);

  @override
  _SearchContactsState createState() => _SearchContactsState();
}

class _SearchContactsState extends State<SearchContacts> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  List<Contact> emergContacts = [];
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController serachController = new TextEditingController();

  @override
  void initState() {
    super.initState();
     getAllContacts();
   serachController.addListener(() {
      filterContacts();
     });
     
  }

  Future<void> getAllContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();       
    setState(() {
      contacts = _contacts;
    });
  }

 Future<void> filterContacts() async {
    List<Contact> _contacts = [];
    
    _contacts.addAll(contacts);
    if (serachController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String serachTerm = serachController.text.toLowerCase();
        var n;
        n = null;
        var phone = contact.phones?.firstWhere((phn) {
          return phn.value!.contains(serachTerm);
        }, orElse: () => n);
        return phone != null;
      });
      setState(() {
        contactsFiltered = _contacts;
      });
    }
   
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = serachController.text.isNotEmpty;

    Future<void> getDoc(String name, var phn) async  {
      var a =  await users
          .doc(user!.email)
          .collection('emergencyContacts')
          .doc(name)
          .get();
      if (!a.exists) {
        users
            .doc(user!.email)
            .collection('emergencyContacts')
            .doc(name)
            .set({'name': name, 'number': phn});
      } else {
        print("Contacts Exists");
      }
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(children: <Widget>[
        Container(
          child: TextField(
            cursorColor: Colors.black,
            controller: serachController,
            decoration: InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.white)),
                prefixIcon: Icon(Icons.search, color: Colors.blueGrey)),
          ),
        ),
       Expanded( 
          child:  ListView.builder(
              shrinkWrap: true,
              itemCount: isSearching == true ? contactsFiltered.length : 0,
              itemBuilder: (context, index) {
                Contact contact =  contactsFiltered[index];
               return ListTile(
                    onTap: () {
                      setState(() {
                        emergContacts.add(contact);
                        var phn = contact.phones!.elementAt(0).value;
                        phn = phn!.replaceAll(' ', '');
                        if (phn.substring(0, 3) == "+91")
                          phn = phn.substring(3);
                        getDoc(contact.displayName.toString(), phn);
                      });
                    },
                    title: Text(
                      contact.displayName ?? "",
                      style: TextStyle(
                          fontFamily: 'Sans-Pro', color: Colors.black),
                    ),
                    subtitle: Text(
                      contact.phones!.elementAt(0).value ?? '',
                      style: TextStyle(
                          fontFamily: 'Sans-Pro', color: Colors.black),
                    ));
              })
       ),
        Padding(
          padding: const EdgeInsets.only(left: 200.0, bottom: 10.0),
          child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.done_rounded),
              backgroundColor: Color(0xff572489),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }),
        )
      ]),
    );
  }
}
