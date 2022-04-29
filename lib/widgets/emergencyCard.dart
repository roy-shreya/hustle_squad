import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmergencyCard extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Icon(Icons.person),
          Text('Sangeetha'),
          Text('9342180400')
        ],
      ),
    );
  }
}