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
import '../../onstreetparking/modal_screens/ussd_code_preview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:http/http.dart' as http;
import '../../onstreetparking/OnStreetLanding.dart';
import '../../Landing.dart';
import '../../shared.dart';
import '../AgentTicketInformation.dart';
import '../Transactions.dart';
import '../VendedTransactions.dart';
import '../constants.dart';



class ussd_payment extends StatefulWidget {
  const ussd_payment({Key? key}) : super(key: key);

  @override
  _ussd_paymentState createState() => _ussd_paymentState();
}

class _ussd_paymentState extends State<ussd_payment> {

String AgentCode ='';
String AgentID ='';


  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentCode = preferences.getString('AgentCode')?? '';
      AgentID = preferences.getString('AgentID')?? '';

    });
  }




  final _formKey = GlobalKey<FormState>();
  bool loading = false;



  var amount= '';


  List<String> hours = [
    'No of Parking Hours', '1', '2','3','4'

  ];

  String dropdownStrHours = 'No of Parking Hours';


  List<String> banklist = [
    'select Customer Bank','GTB', 'FirstBank', 'UnionBank','ZenithBank','UBA','AccessBank','GlobusBank',
    'PolarisBank','FCMB','EcoBank','FidelityBank','HeritageBank','KeystoneBank','Titan',
    'UnityBank','Stanbic','StandardCharteredBank','SterlingBank','JaizBank'

  ];

  String dropdownStr =  'select Customer Bank';

  String platenumber = '';
  String customerEmail = '';
  String firstname = 'John';
  String lastname = 'Doe';
  String phonenumber = '';

  String parkingspotid = '';




  customerUssdPayment() async {
    HttpClient client =  HttpClient();
    // client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.ParkingAgentUSSDPayment;


    if (dropdownStrHours == 'No of Hours'){
      String message = "Choose Duration!!!";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(message),
            actions: <Widget>[
              FlatButton(
                child:  const Text("OK"),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) => fee_payment_ussd()));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    }else{



      final response = await http.post(url, body: {
        "bank": dropdownStr,
         "firstname": firstname,
         "lastname": lastname,
        "phonenumber": phonenumber,
        "customerEmail": customerEmail,
        "platenumber": platenumber,
        "parkingHour": dropdownStrHours,
        "AgentID": AgentID,
        "parkingspotid": parkingspotid,

      });




      String responseData = json.encode(response.body);
      String message = json.decode(responseData);
     print(parkingspotid);


      if(message !=''){

        var localStorage = await SharedPreferences.getInstance();
        localStorage.setString('ussdcode',message);
        localStorage.setString('customerphonenumber',phonenumber);
        localStorage.setString('customerEmail',customerEmail);


        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ussd_code_preview()));


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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));

          },
          icon: const Icon(
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

      body: SingleChildScrollView(
        child: SafeArea(

          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: double.infinity,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),


                // we will give media query height
                // double.infinity make it big as my parent allows
                // while MediaQuery make it big as per the screen

                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // even space distribution
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Pay with USSD",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 40,
                      ),




                      // TextField(
                      //   onChanged :(val){
                      //
                      //     setState(() => firstname = val);
                      //   },
                      //   decoration: InputDecoration(
                      //     // icon: Icon(Icons.account_circle),
                      //     labelText: 'First Name',
                      //   ),
                      // ),
                      //
                      //
                      // TextField(
                      //   onChanged :(val){
                      //
                      //     setState(() => lastname = val);
                      //   },
                      //   decoration: InputDecoration(
                      //     // icon: Icon(Icons.account_circle),
                      //     labelText: 'Last Name',
                      //   ),
                      // ),

                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                          validator: (val) => val!.length < 10 ? 'phonenumber Can\'t Be Empty' : null ,
                          obscureText: false,
                          onChanged: (val){
                            setState(() => phonenumber = val);
                          }
                      ),


                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Email'),
                          validator: (val) => val!.isEmpty
                              ? ' Email is required'
                              : null,
                          onChanged: (val) {
                            setState(() => customerEmail = val);
                          }),










                      const SizedBox(height: 10.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'platenumber'),
                          validator: (val) => val!.isEmpty
                              ? ' platenumber is required'
                              : null,
                          onChanged: (val) {
                            setState(() => platenumber = val);
                          }),



                      const SizedBox(
                        height: 10,
                      ),



                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(hintText: 'Parking Lane'),
                          validator: (val) => val!.length < 1 ? 'phonenumber Can\'t Be Empty' : null ,
                          obscureText: false,
                          onChanged: (val){
                            setState(() => parkingspotid = val);
                          }
                      ),





                      DropdownButton(
                        focusColor: Colors.redAccent,
                        hint: Text("Choose Bank"),
                        isExpanded: true,
                        value: dropdownStr,
                        icon: Icon(Icons.arrow_drop_down),
                        iconEnabledColor: Colors.redAccent,
                        iconSize: 30,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownStr = newValue!;
                          });
                        },
                        items: banklist
                            .map<DropdownMenuItem<String>> ((String value){
                          return DropdownMenuItem<String> (
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      DropdownButton(
                        focusColor: Colors.redAccent,
                        hint: const Text("Choose duration"),
                        isExpanded: true,
                        value: dropdownStrHours,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconEnabledColor: Colors.redAccent,
                        iconSize: 30,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownStrHours = newValue!;
                          });
                        },
                        items: hours
                            .map<DropdownMenuItem<String>> ((String value){
                          return DropdownMenuItem<String> (
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),






                      const SizedBox(
                        height: 30,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {

                            if(_formKey.currentState!.validate()){
                              setState(() => loading = true);

                              customerUssdPayment();
                            }

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => code_generation()));
                          },
                          color: const Color(0xffffcc00),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Generate Code",
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
      ),
    );
  }
}






