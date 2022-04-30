// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final user = FirebaseAuth.instance.currentUser;
  String lat = '', long = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 240.0,
        width: 330.0,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.email.toString())
                .collection('history')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data!.size == 0) {
                return Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("images/nohistory.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0, top: 210.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("No history available!"),
                      ],
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child:  ListView(
                    shrinkWrap: true,
                    children: gethistoryData(snapshot),
                  ),
                );
              }
            }));
  }

  gethistoryData(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return snapshot.data!.docs.map((e) {
      DateTime d = DateTime.parse(e['dateTime'].toDate().toString());
      DateFormat formatDate = DateFormat.yMMMMd('en_US');
      DateFormat formatTime = DateFormat.jm();
      String formatted = formatDate.format(d);
      String formatted1 = formatTime.format(d);
      GeoPoint point = e['location'];
      lat = point.latitude.toString();
      long = point.longitude.toString();

      return Container(
        margin: const EdgeInsets.only(bottom: 32, left: 30, right: 20),
        height: 80,
        width: 20,
        decoration: const BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                      icon: const FaIcon(FontAwesomeIcons.mapMarkerAlt),
                      iconSize: 30,
                      color: Colors.black,
                      onPressed: () {
                        _launchURL();
                      }),
                ],
              ),
              Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    formatted,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Fira-Sans'),
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  formatted1,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Fira-Sans'),
                ),
              ]),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> _launchURL() async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not launch $googleUrl';
    }
  }
}
