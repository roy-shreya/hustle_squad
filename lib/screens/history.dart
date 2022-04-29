import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:nmithacks/welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget { 
  const History({ Key? key }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final user = FirebaseAuth.instance.currentUser;
  String lat='',long='';

  @override
  Widget build(BuildContext context) {
      return  Container(
      child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.email.toString())
                .collection('history')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) return Text("No history available");
              else{
                return Expanded(
                  child: new ListView(
                    shrinkWrap: true,
                    children: gethistoryData(snapshot),
                  ),
                );
              }
            })
      );
  }

  gethistoryData(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
   
     return snapshot.data!.docs.map((e) {
      DateTime d =DateTime.parse(e['dateTime'].toDate().toString());
       DateFormat formatDate = DateFormat.yMMMMd('en_US');
        DateFormat formatTime=DateFormat.jm();
        String formatted = formatDate.format(d);
        String formatted1 = formatTime.format(d);
      GeoPoint point=e['location'];
      lat = point.latitude.toString();
      long = point.longitude.toString();
      
       return Container(
        margin: const EdgeInsets.only(bottom: 32,left: 30,right: 20),
        height: 80,
        width: 5,
        decoration: BoxDecoration(
         color:  Colors.white60,
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.black12.withOpacity(0.4),
            //       blurRadius: 8,
            //       spreadRadius: 2,
            //       offset: Offset(4, 4))
            // ],
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
                    icon: FaIcon(FontAwesomeIcons.mapMarkerAlt),
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: () {
                     _launchURL();
                    }
                    ),
                    
                 ],
              ),
              Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      formatted,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Ubuntu'),
                    ),
                  ), 
                  SizedBox(
                    height: 9,
                  ),
                    Text(
                    formatted1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Ubuntu'),
                      ),
              ]  
              )     ,
          
            ],
          ),
        ),
      );
    }).toList();
  }

 
  Future<void> _launchURL() async {
        String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not launch $googleUrl';
  }
}
  
}