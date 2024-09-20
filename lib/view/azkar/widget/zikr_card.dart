import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ZikrCard extends StatefulWidget {
  final String zkr;
  final String text;
   int count;
  late int counter ;

   ZikrCard({super.key, required this.zkr, required this.count, required this.text});

  @override
  State<ZikrCard> createState() => _ZikrCardState();
}

class _ZikrCardState extends State<ZikrCard> {
  @override
  void initState() {
    super.initState();
    widget.counter = widget.count;
  }

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: (){
            setState(() {
              if(widget.counter >0){
                widget.counter --;
              }

            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  widget.zkr,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        widget.counter = widget.count;
                      });
                    }, icon:  Icon(Icons.refresh,size: 40,
                      color: Colors.blue[900],)),
                    SizedBox(
                      height: Get.height * .08,
                    ),
                    Text(
                      '${widget.counter}',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
