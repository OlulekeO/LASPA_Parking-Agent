import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../Apis/api_base.dart';
import '../../Profile/user_info.dart';
import '../../onstreetparking/HomePage/Home.dart';
import '../../onstreetparking/modal_screens/ussd_code_preview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:http/http.dart' as http;
import 'package:sunmi_printer_plus/sunmi_style.dart';
import '../../Landing.dart';
import '../../shared.dart';
import '../AgentTicketInformation.dart';
import '../OnStreetLanding.dart';
import '../Transactions.dart';
import '../VendedTransactions.dart';
import '../constants.dart';
import 'cash_ticket.dart';



class cash_payment extends StatefulWidget {
  const cash_payment({Key? key}) : super(key: key);

  @override
  _cash_paymentState createState() => _cash_paymentState();
}
DateTime datetime = DateTime.now();
class _cash_paymentState extends State<cash_payment> {

  String AgentCode ='';
  String AgentID ='';


  String codeLink = '';


  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentCode = preferences.getString('AgentCode')?? '';
      AgentID = preferences.getString('AgentID')?? '';
    });
  }



   getCode()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      codeLink = preferences.getString('codeLink')?? '';

    print(codeLink);



    });
  }



  final _formKey = GlobalKey<FormState>();
  bool loading = false;



  var amount= '';


  List<String> hours = [
    'No of Hours', '1', '2','3','4'

  ];



  String dropdownStrHours = 'No of Hours';

  String dropdownStrLanes = 'Select Parking lane';
  List<String> lanes = [
    'Select Parking lane', '1', '2','3','4','5','6'

  ];

  List<String> banklist = [
    'select bank',  'GTB', 'FirstBank', 'UnionBank','ZenithBank','UBA','AccessBank','GlobusBank','PolarisBank'

  ];

  List<String> parking_spot = [];
  //
  // List parking_spot = List(); //edited line
  // var parking_spot = <int>[];
  // var parking_spot = List<int>.empty();

  String parkingspotID='';
  // var data = List.filled(1, 0);


  String dropdownStr =  'select bank';

  String platenumber = '';
  String customerEmail = '';
  String firstname = '';
  String lastname = '';
  String phonenumber = '';

  String channel = 'Cash (Agent)';

  String parkingspotid = '';
  String datetime3 = DateFormat.MMMMEEEEd().format(datetime);

  printTicket(String link) async{


    Uint8List byte = await _getImageFromAsset('assets/LASPAo.png');
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);



    // Uint8List byte = await _getImageFromAsset('https://i.ibb.co/wgSKQ8b/LASPALOGOPNGB.png');

    await SunmiPrinter.initPrinter();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.startTransactionPrint(true);

    await SunmiPrinter.line();
    await SunmiPrinter.printText('Receipt',style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(2);
    // await SunmiPrinter.line();
    // await SunmiPrinter.printText('Align left', style: SunmiStyle(align: SunmiPrintAlign.LEFT));

    await SunmiPrinter.printText('Plate Number' + platenumber, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Phone Number' + phonenumber, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Location' +'Victoria Island', style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Amount' + amount, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('Using the old way to bold!');
    await SunmiPrinter.line();

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // await SunmiPrinter.line();
    // await SunmiPrinter.bold();
    // await SunmiPrinter.printText('Transaction\'s Qrcode');
    await SunmiPrinter.resetBold();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER) ;
    // await SunmiPrinter.printQRCode('https://app.prananet.io/LaspaApp/Qrcode/qrcodes/005_file_4d64df3bbeb6d72d8751596857feed95.png');
    String url = link;
    // convert image to Uint8List format
    Uint8List byte1 = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.printImage(byte1);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(text: 'Name', width: 2, align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: 'Qty', width: 2, align: SunmiPrintAlign.CENTER),
      ColumnMaker(text: 'UN', width: 2, align: SunmiPrintAlign.RIGHT),
      ColumnMaker(text: 'TOT', width: 2, align: SunmiPrintAlign.RIGHT),
    ]);


    await SunmiPrinter.printRow(cols: []);
    //  <a href="https://ibb.co/g9SDWQX"><img src="https://i.ibb.co/wgSKQ8b/LASPALOGOPNGB.png" alt="LASPALOGOPNGB" border="0"></a>
    await SunmiPrinter.exitTransactionPrint(true);
  }



  _ReceiptFinal(context,String message) {

      Alert(
      context: context,
      title: 'Receipt',
      buttons: [],
      content: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            height: 90,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 90,
              child: Image.asset(
                "assets/sucessful.png",
                height: 50,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Payment Successful',
            style: TextStyle(color: Colors.green, fontSize: 16.0),
          ),
          SizedBox(
            height: 20,
          ),

          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),



              child: Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),


                child: Column(


                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/LASPAo.png",
                          height: 70,
                        ),
                        Text(
                          datetime3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        ),



                      ],


                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
          //           Container(
          //           decoration: BoxDecoration(
          //               image: new DecorationImage(
          //               image: new NetworkImage('https://app.prananet.io/LaspaApp/Qrcode/qrcodes/005_file_368a9662346859dd223d409b50fcef8d.png'),
          //     ),
          //   ),
          // ),
                        CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) => Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                          imageUrl:
                          'https://app.prananet.io/LaspaApp/Qrcode/qrcodes/005_file_0fae42bd11b8c1ff44f83774a486adda.png',
                        ),
                        // Image(
                        //   image: message != null ? NetworkImage(message) : null,
                        //   width: 200,
                        // ),
                        // Image.network(
                        //   'message',
                        //   height: 100,
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(

                            left: 20,
                          ),
                          child: Column(

                            children: [

                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: Text("Sam Cromer",
                              //       style: TextStyle(
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 15.0)),
                              // ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(platenumber,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(phonenumber,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                              ),

                              Text("Victoria Island",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),

                              Text(amount,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),



                            ],


                          ),
                        ),


                        // Text(
                        //   ' Wasiu',
                        //   style: TextStyle(color: Colors.black, fontSize: 16.0),
                        // ),



                      ],


                    ),


                  ],
                ),

              ),
            ),
          ),




          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          //     ElevatedButton(
          //
          //         onPressed: () async {
          //           await SunmiPrinter.initPrinter();
          //
          //           await SunmiPrinter.startTransactionPrint(true);
          //           await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
          //           await SunmiPrinter.line();
          //           await SunmiPrinter.printText('Payment receipt');
          //           await SunmiPrinter.printText('Using the old way to bold!');
          //           await SunmiPrinter.line();
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'Name', width: 12, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: 'Qty', width: 6, align: SunmiPrintAlign.CENTER),
          //             ColumnMaker(text: 'UN', width: 6, align: SunmiPrintAlign.RIGHT),
          //             ColumnMaker(text: 'TOT', width: 6, align: SunmiPrintAlign.RIGHT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'Fries', width: 12, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: '4x', width: 6, align: SunmiPrintAlign.CENTER),
          //             ColumnMaker(text: '3.00', width: 6, align: SunmiPrintAlign.RIGHT),
          //             ColumnMaker(text: '12.00', width: 6, align: SunmiPrintAlign.RIGHT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'Strawberry', width: 12, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: '1x', width: 6, align: SunmiPrintAlign.CENTER),
          //             ColumnMaker(text: '24.44', width: 6, align: SunmiPrintAlign.RIGHT),
          //             ColumnMaker(text: '24.44', width: 6, align: SunmiPrintAlign.RIGHT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'Soda', width: 12, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: '1x', width: 6, align: SunmiPrintAlign.CENTER),
          //             ColumnMaker(text: '1.99', width: 6, align: SunmiPrintAlign.RIGHT),
          //             ColumnMaker(text: '1.99', width: 6, align: SunmiPrintAlign.RIGHT),
          //           ]);
          //
          //           await SunmiPrinter.line();
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'TOTAL', width: 25, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: '38.43', width: 6, align: SunmiPrintAlign.RIGHT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'ARABIC TEXT', width: 15, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: 'اسم المشترك', width: 15, align: SunmiPrintAlign.LEFT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'اسم المشترك', width: 15, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: 'اسم المشترك', width: 15, align: SunmiPrintAlign.LEFT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'RUSSIAN TEXT', width: 15, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: 'Санкт-Петербу́рг', width: 15, align: SunmiPrintAlign.LEFT),
          //           ]);
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'Санкт-Петербу́рг', width: 15, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: 'Санкт-Петербу́рг', width: 15, align: SunmiPrintAlign.LEFT),
          //           ]);
          //
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: 'CHINESE TEXT', width: 15, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: '風俗通義', width: 15, align: SunmiPrintAlign.LEFT),
          //           ]);
          //           await SunmiPrinter.printRow(cols: [
          //             ColumnMaker(text: '風俗通義', width: 15, align: SunmiPrintAlign.LEFT),
          //             ColumnMaker(text: '風俗通義', width: 15, align: SunmiPrintAlign.LEFT),
          //           ]);
          //
          //           await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
          //           await SunmiPrinter.line();
          //           await SunmiPrinter.bold();
          //           await SunmiPrinter.printText('Transaction\'s Qrcode');
          //           await SunmiPrinter.resetBold();
          //           await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer');
          //           await SunmiPrinter.lineWrap(2);
          //           await SunmiPrinter.exitTransactionPrint(true);
          //         },
          //         child: const Text('TICKET EXAMPLE')),
          //
          //   ]),
          // ),
          MaterialButton(

            minWidth: double.infinity,
            height: 40,
            color: Color(0xffffcc00),
            onPressed: () async {
              //s
              // String url = 'https://app.prananet.io/LaspaApp/Payment/images/LASPALOGOPNGB.png';
              // // convert image to Uint8List format
              // Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();

              printTicket(message);
              setState(() {
                Transactions();
                VendedTransactions();
                HomePage();

              });
            },
            // defining the shape
            shape: RoundedRectangleBorder(


              // side: BorderSide(
              //     color: Colors.black
              // ),
                borderRadius: BorderRadius.circular(50)

            ),
            child: Text(

              "Print",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,

              ),
            ),
          ),
        ],
      ),

    ).show();
  }


   customerCashPayment() async {
    HttpClient client =  HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.CustomerParkingCreate;


    if (dropdownStrHours == 'No of Hours'){
      String message = "Choose Duration!!!";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child:  Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) => fee_payment_ussd()));
                  setState(() => loading = false);
                },
              ),
            ],
          );
        },
      );

    }else{



      var response = await http.post(url, body: {
        "phonenumber": phonenumber,
        "duration": dropdownStrHours,
        "AgentID": AgentID,
        "PlateNumber": platenumber,
        "channel": channel,
        "parkingspotid": parkingspotid,

      });




      String responseData = json.encode(response.body);
      String message = json.decode(responseData);
      print('test');
       print(message);


      if(message == ''){
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => ussd_code_preview()));




        setState(() {
        });
        String message = "Parking lane Booked!!!!";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(message),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        setState(() => loading = false);
      }
      else{



        // print(message);

        //String img = 'https://app.prananet.io/LaspaApp/Qrcode/QRImage.png';

        setState(() async {
          var localStorage = await SharedPreferences.getInstance();
          localStorage.setString('codeLink',message);
          localStorage.setString('parkingID',message);
          localStorage.setString('platenumber',platenumber);
          localStorage.setString('channel',channel);
          localStorage.setString('phonenumber',phonenumber);

          getCode();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const cash_ticket()));



          // _ReceiptFinal(context,message);

        });



      }
      return message;

    }


  }




  // Future <String>  paywithcashcreate() async {
  //   HttpClient client = new HttpClient();
  //   client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  //
  //   String url = "https://app.prananet.io/LaspaApp/Api/CustomerParkingCreate";
  //   final response = await http.post(url, body: {
  //     "AgentID": AgentID,
  //     "ConcID": 1,
  //     "Location": Location,
  //     "PlateNumber": platenumber,
  //     "duration": '1',
  //     "channel": channel,
  //   });
  //   String responseData = json.encode(response.body);
  //   String message = json.decode(responseData);
  //   //print(message);
  //
  //
  //   if(message.contains("Successful")){
  //     print(message);
  //     _ReceiptFinal(context);
  //     // localStorage = await SharedPreferences.getInstance();
  //     // localStorage.setString('AgentCode',marshalID);
  //     // Navigator.pushReplacement(
  //     //     context, MaterialPageRoute(builder: (context) => Landing()));
  //
  //
  //   }
  //   else{
  //     String message = json.decode(responseData);
  //     print(message);
  //     // setState(() {
  //     // });
  //     // String message = "Error Adding";
  //     // showDialog(
  //     //   context: context,
  //     //   builder: (BuildContext context) {
  //     //     return AlertDialog(
  //     //       title: new Text(message),
  //     //       actions: <Widget>[
  //     //         FlatButton(
  //     //           child: new Text("OK"),
  //     //           onPressed: () {
  //     //             Navigator.of(context).pop();
  //     //           },
  //     //         ),
  //     //       ],
  //     //     );
  //     //   },
  //     // );
  //   }
  //   return message;
  // }




  Future getEmail1()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentCode = preferences.getString('AgentCode')?? '';
      AgentID = preferences.getString('AgentID')?? '';
    });
  }


  @override
  void initState() {
    super.initState();
    getEmail();
    getParkingSpot();
    getEmail1();

  }

  Future getParkingSpot()async{
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.AgentParkingSpot;
    final response = await http.post(url, body: {
      "AgentID": '3'
    });

    var responseData = json.decode(response.body);
    // print (responseData);
    setState(() {
      print (responseData);
    });


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
                context, MaterialPageRoute(builder: (context) => Home()));

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

      body: SingleChildScrollView(
        child: SafeArea(

          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),


                // we will give media query height
                // double.infinity make it big as my parent allows
                // while MediaQuery make it big as per the screen

                width: double.infinity,
                // height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // even space distribution
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Pay with Cash",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(

                          decoration: textInputDecoration.copyWith(hintText: 'Platenumber'),
                          validator: (val) => val!.length < 1 ? 'Platenumber Can\'t Be Empty' : null ,
                          obscureText: false,
                          onChanged: (val){
                            setState(() => platenumber = val);
                          }
                      ),
                      // TextField(
                      //   onChanged :(val){
                      //
                      //     setState(() => platenumber = val);
                      //   },
                      //   decoration: InputDecoration(
                      //     // icon: Icon(Icons.account_circle),
                      //     labelText: 'Plate Number',
                      //     errorText: 'Platenumber Can\'t Be Empty',
                      //   ),
                      //
                      // ),
                      const SizedBox(
                        height: 30,
                      ),

                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                          validator: (val) => val!.length < 8 ? 'phonenumber Can\'t Be Empty' : null ,
                          obscureText: false,
                          onChanged: (val){
                            setState(() => phonenumber = val);
                          }
                      ),
                      // TextField(
                      //   onChanged :(val){
                      //
                      //     setState(() => phonenumber = val);
                      //   },
                      //   decoration: InputDecoration(
                      //     // icon: Icon(Icons.account_circle),
                      //     labelText: 'Phone Number',
                      //   ),
                      // ),












                      const SizedBox(
                        height: 20,
                      ),


                      DropdownButton(
                        focusColor: Colors.redAccent,
                        hint: Text("Choose duration"),
                        isExpanded: true,
                        value: dropdownStrHours,
                        icon: Icon(Icons.arrow_drop_down),
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
                        height: 20,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(hintText: 'Spot number'),
                          validator: (val) => val!.length < 0 ? 'Spot no Can\'t Be Empty' : null ,
                          obscureText: false,
                          onChanged: (val){
                            setState(() => parkingspotid = val);
                          }
                      ),
                      // TextField(
                      //   onChanged :(val){
                      //
                      //     setState(() => parkingspotid = val);
                      //   },
                      //   decoration: InputDecoration(
                      //     // icon: Icon(Icons.account_circle),
                      //     labelText: 'Parking Lane',
                      //   ),
                      // ),


                      const SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () async {

                            if(_formKey.currentState!.validate()){


                              setState(() => loading = true);

                              customerCashPayment();
                            }

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => code_generation()));
                          },
                          color: Color(0xffffcc00),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),

                          child: (loading)
                              ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              )): const Text(
                            "Pay",
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
Future<Uint8List> readFileBytes(String path) async {
  ByteData fileData = await rootBundle.load(path);
  Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  return fileUnit8List;
}

Future<Uint8List> _getImageFromAsset(String iconPath) async {
  return await readFileBytes(iconPath);
}

