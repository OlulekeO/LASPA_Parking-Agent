import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onstreetparking/OnStreetLanding.dart';
import 'Landing.dart';
import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'package:flutter/services.dart';

late SharedPreferences localStorage;
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {

  static const Channel = MethodChannel('com.example.native');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final String _batteryLevel = 'Unknown battery level.';

  Future<void> _showToast() async {
    final String showtoast = await HomePage.Channel.invokeMethod('showtoast',<String,String>{

      'firstname':"AAA09123",
      'lastname':"Praise",
      'phone':"08123456778",
      'email':"workright@gmail.com"

    });

  }

  Future<void> _showToast1() async {
    final String showtoast = await HomePage.Channel.invokeMethod('CardPayment',<String,String>{

      'Amount':"500"
    });

  }

  String AgentID = '';
  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      AgentID = localStorage.getString('AgentID')?? '';
      //  userEmail = localStorage.getString('Email');
    });

    // if(AgentID !=''){
    //
    //   print (AgentID);
    //
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => Home()));
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffD8D8D8),
      body: SafeArea(
        child: Container(
          // we will give media query height
          // double.infinity make it big as my parent allows
          // while MediaQuery make it big as per the screen

          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            // even space distribution
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                height:400,
                width: double.infinity,
                child: Image.asset(
                  "assets/LASPALOGOPNGB.png",
                  height: 30,
                ),
              ),


              Column(
                children: <Widget>[
                  // the login button
                  // MaterialButton(
                  //
                  //   minWidth: double.infinity,
                  //   height: 60,
                  //   color: Color(0xffffcc00),
                  //   onPressed: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  //
                  //   },
                  //   // defining the shape
                  //   shape: RoundedRectangleBorder(
                  //
                  //
                  //     // side: BorderSide(
                  //     //     color: Colors.black
                  //     // ),
                  //       borderRadius: BorderRadius.circular(50)
                  //
                  //   ),
                  //   child: const Text(
                  //
                  //     "Get Started",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 18,
                  //
                  //     ),
                  //   ),
                  // ),

                  MaterialButton(

                    minWidth: double.infinity,
                    height: 60,
                    color: const Color(0xffffcc00),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));


                      // _showToast1();
                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(


                      // side: BorderSide(
                      //     color: Colors.black
                      // ),
                        borderRadius: BorderRadius.circular(50)

                    ),
                    child: const Text(

                      "Get Started",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,

                      ),
                    ),
                  ),
                  // creating the signup button
                  // SizedBox(height:20),
                  // MaterialButton(
                  //   minWidth: double.infinity,
                  //   height: 60,
                  //   onPressed: (){
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                  //
                  //   },
                  //   color: Color(0xFAD98C21),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(50)
                  //   ),
                  //   child: Text(
                  //     "Sign up",
                  //     style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 18
                  //     ),
                  //   ),
                  // )

                ],
              )



            ],
          ),
        ),
      ),
    );
  }
}