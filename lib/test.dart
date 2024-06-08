// import 'package:flutter/material.dart';
//
// class Test extends StatelessWidget {
//   const Test({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text('Test'),
//       ),
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//            CustomContainer('one',Colors.red,context),
//            CustomContainer('two',Colors.blue,context),
//            CustomContainer('three',Colors.black,context),
//            CustomContainer('four',Colors.green,context),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget CustomContainer(String text,Color color,BuildContext context){
//     return  Container(
//       alignment: Alignment.center,
//       width: MediaQuery.of(context).size.width*.95,
//       height: MediaQuery.of(context).size.height*.2,
//       color: color,
//       margin: EdgeInsets.all(15),
//       child: Text('$text',style: TextStyle(fontSize: 30,color: Colors.white),),
//     );
//   }
//
// }
