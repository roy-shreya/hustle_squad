import 'package:flutter/material.dart';
import 'package:nmithacks/providPerm/google_sign_in.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';



class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    //Layout of google sign in button
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 75,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/google.png",
                    height: 48.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: const Text(
                      "Google",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SourceSans'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
