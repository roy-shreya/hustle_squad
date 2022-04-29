import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:nmithacks/providPerm/allPermissions.dart';
import 'package:nmithacks/screens/getLocation.dart';
import 'package:nmithacks/screens/history.dart';
import 'package:nmithacks/widgets/Btn.dart';
import 'package:nmithacks/widgets/bottomnavbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location;
import 'package:geolocator/geolocator.dart' as geolocator;


class HomePageWidget extends StatefulWidget {
  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  TextEditingController _textFieldController = new TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

 // late StreamSubscription<location.LocationData> locationSubscription;
  final geo = Geoflutterfire();
  late String mobile;
  late Timer timer;
  var loc = location.Location();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getCurrentLocation());
    askLocationPermission();
  }

  // @override
  // void deactivate() {
  //   // TODO: implement deactivate
  //   locationSubscription.cancel();
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   locationSubscription.cancel();
  //   super.dispose();
  // }

  // @override
  // void didUpdateWidget(covariant HomePageWidget oldWidget) {
  //   // ignore: todo
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   getCurrentLocation();
  // }

//Ask location permission
  Future askLocationPermission() async {
    final permission = await AllPermissions.getLocationPermission();

    switch (permission) {
      case PermissionStatus.denied:
        print('Permission denied');
        askLocationPermission();
        break;
      case PermissionStatus.granted:
        askContactsPermission();
        break;
      case PermissionStatus.restricted:
        // ignore: todo
        // TODO: Handle this case.
        break;
      case PermissionStatus.limited:
        // ignore: todo
        // TODO: Handle this case.
        break;
      case PermissionStatus.permanentlyDenied:
        print('Permission denied');
        askLocationPermission();
        break;
    }
  }

//Ask contacts Permission
  Future askContactsPermission() async {
    final permission = await AllPermissions.getContactPermission();

    switch (permission) {
      case PermissionStatus.denied:
        print('Permission denied');
        askContactsPermission();
        break;
      case PermissionStatus.granted:
        askForSmsPer();
        break;
      case PermissionStatus.restricted:
        // ignore: todo
        // TODO: Handle this case.
        break;
      case PermissionStatus.limited:
        // ignore: todo
        // TODO: Handle this case.
        break;
      case PermissionStatus.permanentlyDenied:
        print("Permission denied");
        askContactsPermission();
        break;
    }
  }

//Ask for SMS permission
  Future askForSmsPer() async {
    final permission = await AllPermissions.getSmsPermission();

    switch (permission) {
      case PermissionStatus.denied:
        askForSmsPer();
        break;
      case PermissionStatus.granted:
        print('Permission granted');
        getDoc();
        break;
      case PermissionStatus.restricted:
        // ignore: todo
        // TODO: Handle this case.
        break;
      case PermissionStatus.limited:
        // ignore: todo
        // TODO: Handle this case.
        break;
      case PermissionStatus.permanentlyDenied:
        print('Permission denied');
        askForSmsPer();
        break;
    }
  }

//Check if the user is a new user or existing user
  Future getDoc() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var a = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get();
    if (!a.exists) {
      users
          .doc(user!.email)
          .set({'email': user!.email, 'mobile': ""}).whenComplete(() {
        checkMobile();
      });
    } else {
      print("Exists in get doc");
      checkMobile();
    }
  }

  //Display dialog box if mobile number is not there in the firebase
  Future checkMobile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get()
        .then((a) {
      if (a.get('mobile').toString() == "") {
        return _displayTextInputDialog(context);
      } else {
        print("Exists in check mobile");
        setState(() {
          mobile = a.get('mobile');
          getCurrentLocation();
        });
      }
    });
  }

//Keep updating the location on change of it
  Future getCurrentLocation() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get()
        .then((value) {
      setState(() {
        mobile = value.get('mobile');
      });
    });
    print("Mobile no.:$mobile");
     var position = await geolocator.Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);
    var lastKnownPosition =
        await geolocator.Geolocator().getLastKnownPosition();
    print(lastKnownPosition);
    var lat = position.latitude;
    var long = position.longitude;
    GeoFirePoint mylocation = geo.point(
        latitude: lat,
        longitude: long);

    CollectionReference users =
        FirebaseFirestore.instance.collection('locations');
    users.doc(mobile).set({'contactNo': mobile, 'position': mylocation.data});


    // locationSubscription =
    //     loc.onLocationChanged.listen((location.LocationData currentLocation) {
    //   print(currentLocation);
    //   calculate(currentLocation);
    // });
    print("Get Current location called.");
  }

// //Get current location
//   Future<void> calculate(location.LocationData currentLocation) async {
//     GeoFirePoint mylocation = geo.point(
//         latitude: currentLocation.latitude,
//         longitude: currentLocation.longitude);

//     CollectionReference users =
//         FirebaseFirestore.instance.collection('locations');
//     users.doc(mobile).set({'contactNo': mobile, 'position': mylocation.data});
//     // ScaffoldMessenger.of(context)
//     //      .showSnackBar(SnackBar(content: Text('Location added')));
//   }

//Dialog box for mobile number entry
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mobile Number'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter your mobile number"),
            ),
            actions: [
              CustomBtn(
                  inputTxt: "Submit",
                  height: 15.0,
                  width: 30.0,
                  color: Color(0xff00468b),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.email)
                        .update({'mobile': _textFieldController.text}).then(
                            (value) {
                      setState(() {
                        mobile = _textFieldController.text;
                        getCurrentLocation();
                      });
                    });
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffFAF9F6),
                Color(0xffE3CBF4),
              ]),
          image: DecorationImage(
              image: AssetImage(
                "images/girl.png",
              ),
              fit: BoxFit.scaleDown,
              scale: 1.5,
              alignment: Alignment(1, -0.9)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 110,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 16, top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome " + user!.displayName.toString(),
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Sans-Pro',
                            letterSpacing: 0.3,
                            overflow: TextOverflow.fade,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Are you in a need of help immediately?",
                        style: TextStyle(
                            fontFamily: 'Sans-Pro',
                            color: Color(0xffa29aac),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "If yes we are here yo help you.",
                        style: TextStyle(
                            fontFamily: 'Sans-Pro',
                            //letterSpacing: 0.5,
                            color: Color(0xffa29aac),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Press the SOS button below",
                        style: TextStyle(
                            fontFamily: 'Sans-Pro',
                            color: Color(0xffa29aac),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            CustomBtn(
              inputTxt: "SOS",
              width: 160.0,
              height: 66.0,
              color: Colors.red,
              onPressed: () {
                Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => GetLocation()));
              },
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "History",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Sans-Pro',
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  // ignore: prefer_const_constructors
                ],
              ),  
            ),
              History(),

          ],
        ),
      ),
    );
  }
}
