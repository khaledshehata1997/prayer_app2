import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatefulWidget {
 String? hint='';
 var controller;
 var onChanged;
 var scure;

 CustomTextFormField({this.onChanged,this.controller,this.hint,this.scure=false});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*.075,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            obscureText: widget.scure,
            controller: widget.controller,
            onChanged:widget.onChanged(),
            decoration: InputDecoration(
              suffixIcon: widget.scure==true?GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.scure=!widget.scure;
                    });
                  },
                  child: Icon(Icons.remove_red_eye_outlined)):null,
                hintText: '${widget.hint}',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
