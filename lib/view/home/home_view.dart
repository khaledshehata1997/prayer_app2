import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_app/constants.dart';
import 'package:prayer_app/widgets/custom_text.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Get.height*.27 ), // here the desired height
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
              Image.asset('images/Rectangle 1.png'),
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
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'الاذان القادم صلاة العشاء'
                            ,style: TextStyle(
                          fontSize: 25,fontWeight: FontWeight.w800,color: Colors.white),
                      ),
                    ),

                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'بصوت فضيلة الشيخ محمد رفعت'
                        ,style: TextStyle(
                          fontSize: 21,color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'تغيير المؤذن'
                            ,style: TextStyle(
                              decoration:TextDecoration.underline,
                              fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ), Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            '01 :15 :05'
                            ,style: TextStyle(
                              decoration:TextDecoration.underline,
                              fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )

            ],
          )
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topRight,
            child: Text(
              'الصلوات اليومية'
              ,style: TextStyle(
              letterSpacing: .6,
              fontWeight: FontWeight.bold,
                fontSize: 21,color: Colors.black),
            ),
          ),
          SlahBox('الفجر','5.00 ص',false,(){} ),
          SlahBox('الظهر','1.00 ص',true,(){} ),
          SlahBox('العصر','4.00 ص',true,(){} ),
          SlahBox('المغرب','7.00 ص',false,(){} ),
          SlahBox('العشاء','9.00 ص',true,(){} ),
          Text(
            textDirection: TextDirection.rtl,
            'عرض باقي اهداف اليوم',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,
            color: buttonColor,
            decoration: TextDecoration.underline,


          ),), Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.topRight,
            child: Text(
              textDirection: TextDirection.rtl,
              'يمكنك ايضا تصفح باقي المزايا',style: TextStyle(fontSize: 18,
              color: Colors.black,


            ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Column(

                  children: [
                    Icon(Icons.directions),
                    Text('الرقيه الشرعيه',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                width: Get.width*.28,
                height: Get.height*.09,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: .5
                      )
                    ]
                ),
              ),
              Container(
                child: Column(

                  children: [
                    Icon(Icons.directions),
                    Text('القبلة',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                width: Get.width*.28,
                height: Get.height*.09,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: .5
                      )
                    ]
                ),
              ),
              Container(
                child: Column(

                  children: [
                    Icon(Icons.directions),
                    Text('السبحة',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                width: Get.width*.28,
                height: Get.height*.09,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: .5
                      )
                    ]
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget SlahBox(text,time,val,onChanged()){
    return  Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
              activeColor: buttonColor,
              checkColor: Colors.white,
              value: val,
              onChanged: (value){
             onChanged();
              }),

          Text(
            textDirection: TextDirection.rtl,
            '$time',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,

          ),),
          Row(
            children: [
              Text(
                textDirection: TextDirection.rtl,
                ' $text',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,

              ),),
              Icon(Icons.sunny_snowing)
            ],
          )

        ],
      ),
      width: Get.width*.95,
      height: Get.height*.06,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                spreadRadius: .5
            )
          ]
      ),
    );
  }

}
