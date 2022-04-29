import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nmithacks/screens/homepage_widget.dart';
import 'package:nmithacks/welcome.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:telephony/telephony.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart' as geolocator;
import 'dart:math';
import 'package:geoflutterfire/geoflutterfire.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  StreamController<int> _events = new StreamController<int>();
  late Stream<List<DocumentSnapshot>> stream;

  final geo = Geoflutterfire();
  List<Placemark> placemarks = [];
  late Placemark placemark;
  late String sublocality, thoroughfare;
  late BuildContext dialogContext;
  var locationMessage = " ";
  int _counter = 0;
  List<String> emergencyRadiusContacts = [];

  @override
  void initState() {
    super.initState();
    _events = new StreamController<int>();
    _events.add(10);
    _startTimer();
    new Future.delayed(Duration.zero, () {
      alertD(context);
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _events.close();
    getCurrentLocation();
    getRadiusGroup();
    super.deactivate();
  }

  @override
  void dispose() {
    _events.close();
    getCurrentLocation();
    getRadiusGroup();
    super.dispose();
  }

  Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  void _startTimer() {
    _counter = 10;
    // ignore: unnecessary_null_comparison
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        _counter--;
      } else {
        Navigator.pop(dialogContext);
        getCurrentLocation();
        _timer.cancel();
      }
      _events.add(_counter);
    });
  }

  void alertD(BuildContext ctx) {
    var alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        content: StreamBuilder<int>(
            stream: _events.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              print(snapshot.data.toString());
              return Container(
                height: 215,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 15),
                        child: Text(
                          'Are you sure you want to send SOS?',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${snapshot.data.toString()}',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePageWidget()));
                                _timer.cancel();
                              },
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff09009B),
                                        Color(0xff193498),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: Center(
                                    child: Text(
                                  'No',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ), //new column child
                  ],
                ),
              );
            }));
    showDialog(
        context: ctx,
        builder: (BuildContext c) {
          dialogContext = c;
          return alert;
        });
  }

  Future<void> getCurrentLocation() async {
    DateTime now = DateTime.now();
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    Timestamp myTimeStamp = Timestamp.fromDate(now);

    var position = await geolocator.Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);
    var lastKnownPosition =
        await geolocator.Geolocator().getLastKnownPosition();
    print(lastKnownPosition);
    var lat = position.latitude;
    var long = position.longitude;
    var a = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email.toString())
        .collection('history')
        .doc(randomNumber.toString())
        .get();

    while (a.exists) {
      randomNumber = random.nextInt(100);
    }
    await users
        .doc(user?.email.toString())
        .collection('history')
        .doc(randomNumber.toString())
        .set({'dateTime': myTimeStamp, 'location': GeoPoint(lat, long)});

    GeoFirePoint center = geo.point(latitude: lat, longitude: long);
    double radius = 0.5;
    String field = 'position';
    placemarks = await placemarkFromCoordinates(lat, long);
    placemark = placemarks[0];
    sublocality = placemark.subLocality!;
    thoroughfare = placemark.thoroughfare!;
    print("The sublocality is");
    print(sublocality);

    var collectionReferenceOfRadius = _firestore.collection('locations');
    stream = geo
        .collection(collectionRef: collectionReferenceOfRadius)
        .within(center: center, radius: radius, field: field);

if(this.mounted){
    setState(() {
      locationMessage = "http://maps.google.com/?q=$lat,$long";
      getEmergencyContacts();
    });
}
  }

  Future getEmergencyContacts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await users
          .doc(user!.email.toString())
          .collection('emergencyContacts')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((ec) {
          emergencyRadiusContacts.add(ec.data()['number']);
        });
        getRadiusGroup();
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
    //print("The emergency contacts list:");
    //print(emergencyRadiusContacts);
  }

  Future getRadiusGroup() async {
    final user = FirebaseAuth.instance.currentUser;
    String sosPhoneNumber = "";
    await users.doc(user!.email.toString()).get().then((querySnapshot) {
      sosPhoneNumber = querySnapshot.get('mobile');
    });

    stream.listen((List<DocumentSnapshot> documentList) {
      documentList.forEach((element) {
        if (sosPhoneNumber != element.get('contactNo')) {
         // print("Radius number is");
          //print(element.get('contactNo'));
          emergencyRadiusContacts.add(element.get('contactNo'));
         // print(emergencyRadiusContacts);
        } else {
          print('It is the person who is pressing SOS');
        }
      });
    });

    getPoliceStationDetails();
  }

  Future getPoliceStationDetails() async {
    DocumentReference sub = _firestore
        .collection('policeStation/Bengaluru/local/')
        .doc(sublocality);
    await sub.get().then((querySnapshot) {
      emergencyRadiusContacts.add(querySnapshot.get('contactNo'));
    });
    print('The list is');
    print(emergencyRadiusContacts);
    _sendSMS("I NEED HELP! Mylocation: $locationMessage");
  }

  Future<void> _sendSMS(msg) async {
    final Telephony telephony = Telephony.instance;
    for (var phn in emergencyRadiusContacts) {
      telephony.sendSms(
        to: phn,
        message: msg,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 8.0, top: 50.0),
                child: Row(
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
                      'Getting location',
                      style: TextStyle(
                          fontFamily: 'Sans-Pro',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 23,
                          letterSpacing: 0.6),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 150.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 45,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Current Location: ",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      locationMessage,
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}