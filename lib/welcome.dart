import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saathi/providPerm/google_sign_in.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saathi/screens/homepage_widget.dart';
import 'package:saathi/screens/sign_up_widget.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return const HomePageWidget();
              } else {
                return const SignUpWidget();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: const [
      Center(child: CircularProgressIndicator()),
    ],
  );
}
