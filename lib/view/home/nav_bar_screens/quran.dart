import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayer_app/view/home/nav_bar_screens/quran/features/main_screen.dart';
class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity,Get.height*.30), // here the desired height
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
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
                        '"اقرؤوا القران فأنه يأتي يوم القيامه شفيعا لأصحابه"'
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
      body: Column(children: [
        SizedBox(
          height: Get.height * 0.07,
          width: double.infinity,
          child: Card(
            child: ListTile(
              title: Center(child: Text("قراءه القران الكريم",textDirection: TextDirection.rtl,)),
              leading: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainScreen()));
              }, icon: Icon(Icons.arrow_back_ios)),
              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.menu_book_outlined)),
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.07,
          width: double.infinity,
          child: Card(
            child: ListTile(
              title: Center(child: Text("الورد اليومي",textDirection: TextDirection.rtl,)),
              leading: Checkbox(value: false, onChanged: (_){}),
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.07,
          width: double.infinity,
          child: Card(
            child: ListTile(
              title: Center(child: Text("الرقية الشرعيه",textDirection: TextDirection.rtl,)),
              leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.menu_book_outlined)),
            ),
          ),
        ),
      ],),
    );
  }
}
