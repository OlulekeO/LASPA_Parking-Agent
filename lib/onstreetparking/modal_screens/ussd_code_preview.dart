import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../Apis/api_base.dart';
import '../../Profile/user_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:http/http.dart' as http;
import '../../onstreetparking/OnStreetLanding.dart';
import '../../Landing.dart';
import '../AgentTicketInformation.dart';
import '../Transactions.dart';
import '../VendedTransactions.dart';
import '../constants.dart';



class ussd_code_preview extends StatefulWidget {
  const ussd_code_preview({Key? key}) : super(key: key);

  @override
  _ussd_code_previewState createState() => _ussd_code_previewState();
}

class _ussd_code_previewState extends State<ussd_code_preview> {

  String AgentCode ='';
  String AgentID ='';

  String ussdcode = '';

  String customerphonenumber = '';
  String customerEmail = '';


  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentCode = preferences.getString('AgentCode')?? '';
      AgentID = preferences.getString('AgentID')?? '';
      ussdcode = preferences.getString('ussdcode')?? '';
      customerphonenumber = preferences.getString('customerphonenumber')?? '';
      customerEmail = preferences.getString('customerEmail')?? '';



    });
  }






  final _formKey = GlobalKey<FormState>();
  bool loading = false;



  var amount= '';


  List<String> hours = [
    'No of Hours', '1', '2','3','4'

  ];

  String dropdownStrHours = 'No of Hours';


  List<String> banklist = [
    'select bank',  'GTB', 'FirstBank', 'UnionBank','ZenithBank','UBA','AccessBank','GlobusBank','PolarisBank'

  ];

  String dropdownStr =  'select bank';

  String platenumber = '';

  String firstname = '';
  String lastname = '';
  String phonenumber = '';





  Future<String> customerUssdPushlink() async {

    HttpClient client =  HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.ParkingAgentpushUSSDcode;


    final response = await http.post(Uri.parse(url), body: {
      "phonenumber": phonenumber,
      "customerEmail": customerEmail,
      "ussdcode": ussdcode,
      "AgentID": AgentID,
    });




    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    print(message);


    if(message.contains("Code has been sent")){



      // var localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('ussdcode',message);

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => ussdParkingPayment()));

      setState(() {
      });
      String message = "USSD Code sent!!!!!";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(message),
            actions: <Widget>[
              FlatButton(
                child:  const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                },
              ),
            ],
          );
        },
      );
    }
    else{
      setState(() {
      });
      String message = "Something went wrong!!!!!";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return message;


  }






  @override



  void initState() {
    super.initState();
    getEmail();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffB6B6B6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey.shade700,
              size: 30,
            ),
          )
        ],

      ),

      body: SafeArea(

        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),


              // we will give media query height
              // double.infinity make it big as my parent allows
              // while MediaQuery make it big as per the screen

              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  // even space distribution
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("USSD Code Preview",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      height: 40,
                    ),


                    Center(
                      child: Text(
                        ussdcode,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),



                    const SizedBox(
                      height: 40,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async {
                          final response = await customerUssdPushlink();


                          // String message = "Ussd code on its way";
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: new Text(message),
                          //       actions: <Widget>[
                          //         FlatButton(
                          //           child: new Text('Ok'),
                          //           onPressed: () {
                          //             Navigator.of(context).pop();
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );


                        },
                        color: Color(0xffffcc00),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Push link",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}






