// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laspa_ok/thank.dart';
// import 'onstreetparking/HomePage/Home.dart';
import 'splash.dart';



void main() {




  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Welcome',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage()
      ));
}
// class HomePage extends StatefulWidget {
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final String channel = "callMrFlutter";
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     MethodChannel(channel).setMethodCallHandler((call) async {
//       if (call.method == "showToast") {
//
//         Navigator.push(context, MaterialPageRoute(builder: (context) => result_page()));
//
//         //
//         // Fluttertoast.showToast(msg: "Flutter is running now",
//         //     backgroundColor: Colors.red,
//         //     textColor: Colors.white);
//       }else{
//
//         Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
//       }
//       return null;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
