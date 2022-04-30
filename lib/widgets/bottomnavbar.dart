import 'package:flutter/material.dart';
import 'package:nmithacks/providPerm/google_sign_in.dart';
import 'package:nmithacks/screens/google_maps.dart';
import 'package:nmithacks/screens/homepage_widget.dart';
import 'package:nmithacks/screens/profile.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import '../screens/EmergencyContact.dart';
// ignore: import_of_legacy_library_into_null_safe

//Creating a Bottom Nav Bar which contains 3 icons
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,     
        children: <Widget>[
          Padding(
    //Layout of Home button
        padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            final provider =
                Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePageWidget()));
          },
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 75,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white24),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Image.asset(
                    "images/home.png",
                    height: 55.0,
                    scale: 3.0,
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      "Home",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SourceSans'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
          BottomNavItem(
            svgScr: "images/profile.png",
            press: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));   
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> GoogleMaps()));         
            },
          ),
          BottomNavItem(
            svgScr: "images/contacts.jpg",
            press: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContact()));
            },
          ),
          BottomNavItem(
            svgScr: "images/logout.png",
            press: (){
              exitApp(context);
            },
          ),
        ],
      ),
    );
  }
}


//Bottom Nav bar Item Class
class BottomNavItem extends StatelessWidget {
  final String svgScr;
  final String title;
  final press;
  final bool isActive;
  const BottomNavItem({
    Key? key,
     required this.svgScr,
    this.title='',
     this.press,
    this.isActive = false, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ImageIcon(
            AssetImage(svgScr),
            color: Colors.orange,
            //color: Colors.black54,
     size: 24,
          ),
        ],
      ),
    );
  }
}

//For logging out of the app
void exitApp(BuildContext context){
      var alertDialog= AlertDialog(
                title: Text("Exit"),
                content: Text("Are you sure you want to exit?",style: TextStyle(color: Colors.deepPurple),),
                actions: [
                  TextButton(
                    child: Text("Yes",style: TextStyle(color: Colors.deepPurpleAccent),),
                    onPressed: (){
                       final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
                    },
                  ),
                  TextButton(
                    child: Text("No",style: TextStyle(color: Colors.deepPurpleAccent),),
                    onPressed: ()=>
                      Navigator.of(context).pop(),          
                  ),
                ],
              );

    showDialog(context: context, builder:(BuildContext context){
      return alertDialog;
    });
}