import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsList extends StatefulWidget {
  final String userEmail;

  const ContactsList({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userEmail)
            .collection('emergencyContacts')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var lengthOfDatabase = snapshot.data?.size ?? 0;
          if (lengthOfDatabase == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Text(
                  "There are no emergency contacts",
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }
          else{
            return Expanded(
            child: new ListView(
              shrinkWrap: true,
              children: getemergContacts(snapshot),
            ),
          );
          }
        });
  }

  getemergContacts(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((e) {
      return Container(
        margin: const EdgeInsets.only(bottom: 32,left: 20,right:20),
       // width: 20,
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.person_rounded,size: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      e['name'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Sans-Pro'),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 30.0,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      //   _onDeleteItemPressed(index);
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userEmail)
                          .collection('emergencyContacts')
                          .doc(e['name'])
                          .delete();
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 160.0),
                    child: Text(
                      e['number'],
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xffFEAD1D),
                          fontFamily: 'Sans-Pro'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }).toList();
  }
}
