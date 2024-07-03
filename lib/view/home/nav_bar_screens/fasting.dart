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
          appBar: PreferredSize(
            preferredSize: Size(Get.width,Get.height*.33), // here the desired height
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  bottom: TabBar(
                      tabs: [
                        Tab(text: "الكفارة والقضاء"),
                        Tab(text: "النوافل",)
                      ]),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),

                ),
                Image.asset('images/Rectangle 1.png',fit: BoxFit.fitWidth,
                  width: Get.width,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35,horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround  ,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Image.asset('icons/img_1.png',width: 20,height: 20,),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.notifications_none),
                                backgroundColor: Colors.white,
                                radius: 15,
                              ),
                              SizedBox(width: 15,),
                              CircleAvatar(
                                radius: 15,
                                child: Image.asset('icons/img.png',width: 20,height: 20,),
                                backgroundColor: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'قال رسول الله صلي الله عليه وسلم:'
                            ,textDirection: TextDirection.rtl
                            ,style: TextStyle(
                              fontSize: 25,fontWeight: FontWeight.w800,color: Colors.white),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'قال الله عز وجل: "كل عمل ابن ادم له الا الصيام;فأنه لي وانا اجزي به"'
                            ,textDirection: TextDirection.rtl
                            ,style: TextStyle(
                              fontSize: 21,color: Colors.white),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

          ),

          body: TabBarView(children: _tabs)
      ),
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
            title: Center(child: Text("رمضان 2024",textDirection: TextDirection.rtl,)),
            leading: IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down_outlined)),
            trailing: Text("ايام 5",textDirection: TextDirection.rtl,),
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
