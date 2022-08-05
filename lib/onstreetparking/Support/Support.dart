import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laspa_ok/onstreetparking/Support/supportBody.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../Landing.dart';
import '../VendedTransactions.dart';
import '../constants.dart';


late SharedPreferences localStorage;

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field  state
  String marshalID = '';
  String ConcID = '1';
  String Location = '';
  String duration = '';
  String phone = '';
  String platenumber = '';
  String amount = '';

  TextEditingController durationController = TextEditingController();
  TextEditingController platenumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();




  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  String SubMarshalID = '1';

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      marshalID = preferences.getString('AgentCode')?? '';
    });
  }


  launchCall() async{
    String telephoneNumber = '+2348038430865';
    String telephoneUrl = "tel:$telephoneNumber";
    if (await canLaunch(telephoneUrl)) {
      await launch(telephoneUrl);
    } else {
      throw "Error occured trying to call that number.";
    }

  }
  launchPhone() async{
    String telephoneNumber = '+2348038430865';
    String telephoneUrl = "tel:$telephoneNumber";
    if (await canLaunch(telephoneUrl)) {
      await launch(telephoneUrl);
    } else {
      throw "Error occured trying to call that number.";
    }

  }



  launchBrowser() async{


    const url = 'https://www.laspa.lg.gov.ng';
    if(await canLaunch(url)){
      await launch(url);
    }else {
      throw 'Could not launch $url';
    }
  }


  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      SubMarshalID = localStorage.getString('AgentCode')?? '';
      //  userEmail = localStorage.getString('Email');
    });
  }
  @override

  void initState() {
    super.initState();
    getEmail();
  }
  //String SubMarshalID1 = '3';





  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      appBar: new AppBar(
        backgroundColor: Color(0xffffcc00),
        centerTitle: false,
        title: Center(
            child: Text(
              "Support",
              style: TextStyle(
                color: Color(0xff000000),
              ),
            )),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              // we will give media query height
              // double.infinity make it big as my parent allows
              // while MediaQuery make it big as per the screen

              width: double.infinity,
              // height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                // even space distribution
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[



                      // RaisedButton(
                      //   onPressed: (){
                      //     _showSimpleModalDialog(context);
                      //   },
                      //   child: Text('Simple Dialog Modal'),
                      // ),

                      Card(
                        child: ExpansionTile(

                          title: const Text('Customer Care',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,),
                          ),
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),

                            GestureDetector(
                              onTap: (){

                                launchBrowser();

                              },
                              child: const Text('https://www.laspa.lg.gov.ng/',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),


                      SizedBox(
                        height: 10,
                      ),

                      Card(
                        child: ExpansionTile(

                          title: const Text('Support',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,),
                          ),
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),

                            GestureDetector(
                              onTap: (){

                                launchCall();

                              },
                              child: const Text('+2348038430865',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),




                      SizedBox(
                        height: 10,
                      ),

                      Card(
                        child: ExpansionTile(

                          title: const Text('FAQ',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,),
                          ),
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),

                            GestureDetector(
                              onTap: (){

                                launchBrowser();

                              },
                              child: const Text('https://www.laspa.lg.gov.ng/',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),





                    ],
                  ),
                  // Container(
                  //   height:500,
                  //   width: double.infinity,
                  //   // height: MediaQuery.of(context).sizse.height / 3,
                  //   decoration: BoxDecoration(
                  //
                  //       image: new DecorationImage(
                  //         image: AssetImage("assets/LASPAo.png"),
                  //         // fit: BoxFit.cover
                  //
                  //       )
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
