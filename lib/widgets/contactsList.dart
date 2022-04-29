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
                  style: TextStyle(color: Colors.white),
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
        margin: const EdgeInsets.only(bottom: 32),
        height: 88,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff5089C6), Color(0xff5089C6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(4, 4))
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      e['name'],
                      style: TextStyle(
                          color: Colors.white,
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
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      e['number'],
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
