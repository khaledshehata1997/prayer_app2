import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatefulWidget {
 String? hint='';
 var controller;
 var onChanged;
 var scure;
 var txt1;
 var txt2;
 void Function(String?)? onSaved;

 CustomTextFormField({this.onChanged,this.controller,this.hint,this.scure=false,this.txt1,this.txt2,this.onSaved});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*.05,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
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
