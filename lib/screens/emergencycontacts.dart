import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nmithacks/welcome.dart';
import 'package:nmithacks/widgets/contactsList.dart';
import 'package:nmithacks/widgets/search_contacts.dart';


class EmergencyContacts extends StatefulWidget {
  const EmergencyContacts({Key? key}) : super(key: key);

  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  Future<void> showContacts(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            backgroundColor: Color(0xffEEEEEE),
            child: SearchContacts(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  
  Future beInPage() async {
    setState(() {});
  }

  Future goToHomePage() async {
     
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff21254A),
        body: Container(
          padding: EdgeInsets.only(left: 15.0, right: 8.0, top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()));
                    },
                  ),
                  Text(
                    'Your Emergency Contacts',
                    style: TextStyle(
                        fontFamily: 'Sans-Pro',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 23,
                        letterSpacing: 0.6),
                  ),
                ],
              ),
              ContactsList(userEmail: user!.email.toString()),
              const SizedBox(height: 40.0,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 7.0, bottom: 60.0,),
                  child: FloatingActionButton(
                      child: Icon(
                        Icons.person_add,
                        color: Colors.black87,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        await showContacts(context);
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}