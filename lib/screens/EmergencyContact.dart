import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nmithacks/widgets/bottomnavbar.dart';

import '../widgets/emergencyCard.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({Key? key}) : super(key: key);

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Card(
              color:Colors.white,
              child: Row(
                children: [
                  Icon(Icons.person),
                  Text('Sangeetha'),
                  Text('9342180400')
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
