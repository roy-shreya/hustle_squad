import 'package:flutter/material.dart';
import 'package:nmithacks/widgets/google_signup_widget.dart';
// ignore: import_of_legacy_library_into_null_safe

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //Layout of sign in page
    return Scaffold(
        body: Container(
      //background colour
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Color(0xffFAF9F6),
            Color(0xffE3CBF4),
          ])),

      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 5,
            ),
            //Login Image
            Container(
              height: size.height / 3,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/login.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Saathi",
              style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Yanone'),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Login to your account",
              style: TextStyle(
                fontSize: size.width / 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Sans-Pro',
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            GoogleSignupButtonWidget()
          ],
        ),
      ),
    ));
  }
}
