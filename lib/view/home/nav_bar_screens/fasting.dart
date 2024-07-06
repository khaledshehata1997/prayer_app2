import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
class Fasting extends StatefulWidget {
  const Fasting({super.key});

  @override
  State<Fasting> createState() => _FastingState();
}
final List<Widget> _tabs = [
  Kaffara(),
  Nwafil()
];

class _FastingState extends State<Fasting> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/back ground.jpeg'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.white,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: Get.height * .06,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade400,
                              child: Image.asset(
                                'icons/img_1.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.notifications_none),
                              backgroundColor: Colors.grey.shade400,
                              radius: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            CircleAvatar(
                              radius: 20,
                              child: Image.asset(
                                'icons/img.png',
                                width: 20,
                                height: 20,
                              ),
                              backgroundColor: Colors.grey.shade400,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .03,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'images/back ground2.jpeg',
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'رسول الله صلي الله عليه وسلم قال:',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textDirection: TextDirection.rtl,
                              '"قال الله عز وجل: كل عمل ابن ادم له الا الصيام\n فانه لي وانا اجزي به"',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: const TabBar(
                      //controller: _controller,
                      tabs: [
                        Tab(
                          text: 'الكفارة والقضاء',
                        ),
                        Tab(
                          text: 'النوافل',
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: TabBarView(children: _tabs))
                ],
              )
            ],
          )
      ),
    );
  }
  Widget customSalah(text,text2){
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
            children: [
              Text(
                text,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                textDirection: TextDirection.rtl,
                text2,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down_outlined))
            ],
          ),
      width: Get.width * .95,
      height: Get.height * .06,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                spreadRadius: .5)
          ]),
    );
  }
}
Widget Kaffara(){
  return Column(
    children: [
      SizedBox(
        height: Get.height * 0.07,
        width: double.infinity,
        child: Card(
          child: ListTile(
            title: Center(child: Text("كفارة",textDirection: TextDirection.rtl,)),
            leading: IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down_outlined)),
            trailing: Text("ايام 5",textDirection: TextDirection.rtl,),
          ),
        ),
      ),
    ],
  );
}
Widget Nwafil(){
  return Column(
    children: [
      SizedBox(
        height: Get.height * 0.15,
        width: double.infinity,
        child: Card(
          child: ListTile(
            title: Text("صوم الاثنين والخميس",textDirection: TextDirection.rtl,),
            subtitle: Text("عند التفعيل يضاف الي فائمه الاهداف ايام الاثنين والخميس",textDirection: TextDirection.rtl,),
            leading: Checkbox(value: false, onChanged: (_){}),
          ),
        ),
      ),
      SizedBox(
        height: Get.height * 0.07,
        width: double.infinity,
        child: Card(
          child: ListTile(
            title: Center(child: Text("كفارة",textDirection: TextDirection.rtl,)),
            leading: IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down_outlined)),
          ),
        ),
      ),
    ],
  );

}
