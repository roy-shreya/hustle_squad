import 'package:flutter/material.dart';
import 'package:nmithacks/utlis/general_size.dart';

// ignore: must_be_immutable
class CustomBtn extends StatefulWidget {
  final String inputTxt;
  final double height,width;
  final onPressed;
  final color;
  CustomBtn({ Key? key,required this.inputTxt,required this.height,required this.width,this.color,this.onPressed}) : super(key: key);

  @override
  _CustomBtnState createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        child: MaterialButton(
      minWidth:widget.width,
      height: widget.height,
      color: widget.color ,
      elevation: 0,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      ),
     child: Text(
       widget.inputTxt,
       style: const TextStyle(
         fontSize:20.0,
         fontFamily: 'Sans-Pro',
         fontWeight: FontWeight.w700,
         color: Colors.white
       ),
     ),
     onPressed: widget.onPressed
     ),
    );
  }
}
