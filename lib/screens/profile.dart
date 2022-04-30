// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:nmithacks/screens/homepage_widget.dart';
import 'package:nmithacks/widgets/bottomnavbar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';


class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final geo = Geoflutterfire();
  String fullname = '';
  String mobile = '';
  
  bool showPassword = false;
  final namecon = TextEditingController();
  final mobilecon = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final String _imageFile = FirebaseAuth.instance.currentUser!.photoURL.toString();
  

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.email)
        .get()
        .then((a) {
      setState(() {
        fullname = a.get('name').toString();
        mobile = a.get('mobile').toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      //Color(0xffD5EEFF),
      //Color(0xffEDF9FC),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white,fontSize: 22.0, fontWeight: FontWeight.w500, fontFamily: 'Fira-Sans'),
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
          
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              
                              shape: BoxShape.circle,
                              
                              image:  DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(user!.photoURL.toString())
                                  )
                                  ),
                        ),
      
                        // Positioned(
                        //     bottom: 0,
                        //     right: 0,
                        //     child: Container(
                        //       height: 40,
                        //       width: 40,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         border: Border.all(
                        //           width: 4,
                        //           color:
                        //               Theme.of(context).scaffoldBackgroundColor,
                        //         ),
                        //         color: Colors.blue,
                        //       ),
                        //       child: const Icon(
                        //         Icons.edit,
                        //         color: Colors.white,
                        //       ),
                        //     )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  buildTextField("Full Name", fullname, false, namecon),
                  buildTextField("Mobile Number", mobile, false, mobilecon),
                  // buildTextField("Location ", "TLV, Israel", false),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                    child: RaisedButton(
                      onPressed: () {
                        updateDetails();
                      },
                      color: Color(0xff572489),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                            fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController cont) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 25.0, right: 25.0),
      child: TextField(
        // enableInteractiveSelection: false,
        // focusNode: FocusNode(),
        controller: cont,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
          
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Future<void> updateDetails() async {
    String name = namecon.text;
    String mobileNumberNew = mobilecon.text;
    int count = 0;
    setState(() {
      if (name == '') {
        name = fullname;
        count++;
      }
     
      if (mobileNumberNew == '') {
        mobileNumberNew = mobile;
        count++;
      }
    });
    if (count == 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No updation done')));
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.email)
          .update({
        'name': name,
        'mobile': mobileNumberNew,
        //'location': GeoPoint(lat, long),
      }).then((value) {
        setState(() {
          fullname = name;
          mobile = mobileNumberNew;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your Details are updated')));
        });
      });
    }
  }

}
