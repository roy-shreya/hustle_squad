//@dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nmithacks/welcome.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  static const String title = 'Saathi App';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: WelcomePage(),
      );
}