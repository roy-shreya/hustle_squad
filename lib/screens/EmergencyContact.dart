import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nmithacks/screens/homepage_widget.dart';
import 'package:nmithacks/widgets/bottomnavbar.dart';
import 'package:nmithacks/widgets/contactsList.dart';
import 'package:nmithacks/widgets/search_contacts.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({Key? key}) : super(key: key);

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  final user = FirebaseAuth.instance.currentUser;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xff572489),
        
        //const Color(0xff5893D4),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePageWidget()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color(0xffFAF9F6),
              Color(0xffE3CBF4),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            ContactsList(userEmail: user!.email.toString()),
            SizedBox(height: 250),
            Container(
              width: 180,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 7.0,
                  bottom: 60.0,
                ),
                child: FloatingActionButton(
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    backgroundColor:Color(0xff572489),
                    onPressed: () async {
                      await showContacts(context);
                    }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
