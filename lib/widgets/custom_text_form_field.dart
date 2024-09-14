import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class CustomTextFormField extends StatefulWidget {
 String? hint='';
 var controller;
 var onChanged;
 var scure;
 var isPassword;
 var txt1;
 var txt2;
 void Function(String?)? onSaved;

 CustomTextFormField({this.onChanged,this.controller,this.hint,this.scure=false,this.txt1,this.txt2,this.onSaved,this.isPassword=false});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*.06,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            obscureText: widget.scure,
            controller: widget.controller,
            onChanged:widget.onChanged(),
            onSaved: widget.onSaved,
            validator: (val){
              if(val!.length> 100){
                return widget.txt1;
              }
              if(val.length < 4){
                return widget.txt2;
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon:widget.isPassword?GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.scure=!widget.scure;
                    });
                  },
                  child: widget.scure? const Icon(Icons.visibility_off_outlined):const Icon(Icons.visibility_outlined)):null,

              // suffixIcon:  widget.scure==true?GestureDetector(
              //     onTap: (){
              //       setState(() {
              //         widget.scure=!widget.scure;
              //       });
              //     },
              //     child: const Icon(Icons.visibility_off_outlined)):null,
                
                hintText: '${widget.hint}',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonColor,width: 2),
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
