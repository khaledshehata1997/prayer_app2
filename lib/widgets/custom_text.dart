import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  Alignment? alignment;
  String? text;
  double? size;
  Color? color;
  bool? isBold;
  bool? lineUnderText;

  CustomText({this.text,this.color=Colors.black,this.size,this.isBold=false,this.alignment=Alignment.topRight,this.lineUnderText=false});


  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(right: 10,top: 5),
      alignment:alignment,
      child: Text('$text',style: TextStyle(
          decoration:lineUnderText==true? TextDecoration.underline:null,
          fontSize: size,
          fontWeight:isBold==true?FontWeight.bold:FontWeight.normal,
          color: color
      ),),
    );
  }
}
