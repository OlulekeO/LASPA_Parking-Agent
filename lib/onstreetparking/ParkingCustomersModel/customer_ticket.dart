import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../Apis/api_base.dart';
import '../../Home.dart';


import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../Profile/user_info.dart';
import '../../onstreetparking/HomePage/Home.dart';
import '../../onstreetparking/modal_screens/ussd_code_preview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../../Landing.dart';
import '../AgentTicketInformation.dart';
import '../OnStreetLanding.dart';
import '../Transactions.dart';
import '../VendedTransactions.dart';
import '../constants.dart';



late SharedPreferences localStorage;

late String AgentID;

class Parking {
  final String ParkingID,AgentID,ExpiringTime,ParkingTime,ParkingAreaID,ParkingSpotID,qrcode,ParkingAreaName,ParkingSpotName,Qrimage;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  Parking({
    required this.ParkingID,
    required this.AgentID,
    required this.Location,
    required this.ParkingTime,
    required this.PlateNumber,
    required this.ParkingHour,
    required this.ExpiringTime,

    required this.Parkingstatus,
    required this.channel,
    required this.TrnxRef,
    required this.DateAdded,
    required this.DateCreated,
    required this.Amount,
    required this.ParkingAreaID,
    required this.ParkingSpotID,
    required this.qrcode,
    required this.Qrimage,
    required this.ParkingAreaName,
    required this.ParkingSpotName,


  });

  factory Parking.fromJson(Map<String, dynamic> jsonData) {
    return Parking(
      ParkingID: jsonData['ParkingID'],
      AgentID: jsonData['AgentID'],
      Location: jsonData['Location'],
      PlateNumber: jsonData['PlateNumber'],
      ParkingHour: jsonData['ParkingHour'],
      ExpiringTime: jsonData['ExpiringTime'],
      ParkingTime: jsonData['ParkingTime'],
      Parkingstatus: jsonData['Parkingstatus'],
      channel:jsonData['channel'],
      TrnxRef:jsonData['TrnxRef'],
      DateAdded:jsonData['DateAdded'],
      DateCreated:jsonData['DateCreated'],
      Amount:jsonData['Amount'],
      ParkingAreaID:jsonData['ParkingAreaID'],
      ParkingSpotID:jsonData['ParkingSpotID'],
      Qrimage:jsonData['Qrimage'],
      qrcode: Apis.QrcodeLocationAlt1 +jsonData['Qrimage'],
      ParkingAreaName:jsonData['ParkingAreaName'],
      ParkingSpotName:jsonData['ParkingSpotName'],






    );
  }
}

late final List<Parking> parkings;
class User {
  final String ParkingID,AgentID;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  User({
    required this.ParkingID,
    required this.AgentID,
    required this.Location,
    required this.PlateNumber,
    required this.ParkingHour,
    required this.Parkingstatus,
    required this.channel,
    required this.TrnxRef,
    required this.DateAdded,
    required this.DateCreated,
    required this.Amount,
  });
}

Widget build(context) {
  return ListView.builder(
    itemCount: parkings.length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem2(parkings[currentIndex], context);
    },
  );
}


class CustomListView5 extends StatefulWidget {
  final List<Parking> spacecrafts5;

  CustomListView5(this.spacecrafts5);

  @override
  State<CustomListView5> createState() => _CustomListView5State();
}
DateTime datetime = DateTime.now();
class _CustomListView5State extends State<CustomListView5> {
  // Future getEmail()async{
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     SubMarshalID = preferences.getString('AgentCode');
  //   });
  // }



  static const Channel = MethodChannel('com.example.native');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';


  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
       batteryLevel = 'Battery level at $result % .';
     // print(batteryLevel);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const result_page()),
      // );

    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _showToast() async {
    final String showtoast = await Channel.invokeMethod('showtoast',<String,String>{

      'firstname':"AAA09123",
      'lastname':"Praise",
      'phone':"08123456778",
      'email':"workright@gmail.com"
    });

  }

  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      AgentID = localStorage.getString('AgentID')?? '';
      //  userEmail = localStorage.getString('Email');
    });
  }
  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentID = preferences.getString('AgentID')?? '';
    });
  }



  @override
  void initState() {
    super.initState();
    getEmail();
    getCode();
    //getRequest();
  }

  String platenumber = '';
  String customerEmail = '';
  String firstname = '';
  String lastname = '';
  String phonenumber = '';

  String channel = 'Cash (Agent)';

  String amount = '';

  String codeLink = 'https://app.prananet.io/LaspaApp/Qrcode/QRImage.png';

  getCode()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //codeLink = preferences.getString('codeLink');
      // codeLink = (preferences.getString('codeLink')??'');
      platenumber = preferences.getString('platenumber')?? '';
      channel = preferences.getString('channel')?? '';
      phonenumber = preferences.getString('phonenumber')?? '';
      //
      // print(codeLink);
      // print(platenumber);
      // print(channel);


    });
  }


  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }




  Widget build(context) {
    return ListView.builder(
      itemCount: widget.spacecrafts5.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem2(widget.spacecrafts5[currentIndex], context);
      },
    );
  }
}



Widget createViewItem2(Parking parkings, BuildContext context) {

   const Channel = MethodChannel('com.example.native');
   const platform = MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';





   String datetime3 = DateFormat.MMMMEEEEd().format(datetime);

  return ListTile(
      title: Column(

        children: [

          DottedBorder(
            borderType: BorderType.RRect,
            // radius: Radius.circular(12),
            padding: EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),


              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: double.infinity,
                ),

                width: double.infinity,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //           Container(
                        //           decoration: BoxDecoration(
                        //               image: new DecorationImage(
                        //               image: new NetworkImage('https://app.prananet.io/LaspaApp/Qrcode/qrcodes/005_file_368a9662346859dd223d409b50fcef8d.png'),
                        //     ),
                        //   ),
                        // ),

                        Column(

                          children: [



                            Text(parkings.ParkingAreaName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0)),


                            Image.network(
                              parkings.qrcode,
                              height: 100,
                            ),

                            // CachedNetworkImage(
                            //   progressIndicatorBuilder: (context, url, progress) => Center(
                            //     child: CircularProgressIndicator(
                            //       value: progress.progress,
                            //     ),
                            //   ),
                            //   imageUrl:
                            //   codeLink,
                            //   height: 100,
                            // ),

                          ],



                        ),



                        // Image(
                        //   image: message != null ? NetworkImage(message) : null,
                        //   width: 200,
                        // ),

                        Expanded(
                          child: Padding(
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
                                  child: Text("Platenumber: "+ parkings.PlateNumber,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)),
                                ),
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(parkings.PlateNumber,
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 15.0)),
                                // ),

                                const SizedBox(
                                  height: 10,
                                ),
                                Text("Parking spot: "+ parkings.ParkingSpotName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Amount: "+"₦ "+ parkings.Amount,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),

                                SizedBox(
                                  height: 10,
                                ),
                                Text("Park Time: "+ parkings.ParkingTime,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("End Time: "+ parkings.ExpiringTime,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),




                              ],


                            ),
                          ),
                        ),


                        // Text(
                        //   ' Wasiu',
                        //   style: TextStyle(color: Colors.black, fontSize: 16.0),
                        // ),



                      ],


                    ),

                    // Image.network(
                    //   codeLink,
                    //   height: 100,
                    // ),


                  ],
                ),

              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          // MaterialButton(
          //
          //   minWidth: double.infinity,
          //   height: 40,
          //   color: Color(0xffffcc00),
          //   onPressed: () async {
          //     //s
          //     // String url = 'https://app.prananet.io/LaspaApp/Payment/images/LASPALOGOPNGB.png';
          //     // // convert image to Uint8List format
          //     // Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
          //
          //     printTicket(parkings);
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
          //     "Print",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w600,
          //       fontSize: 18,
          //
          //     ),
          //   ),
          // ),

    MaterialButton(

      minWidth: double.infinity,
      height: 40,
      color: const Color(0xffffcc00),
      onPressed: () async {
        //s
        // String url = 'https://app.prananet.io/LaspaApp/Payment/images/LASPALOGOPNGB.png';
        // // convert image to Uint8List format
        // Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();

        _showToast(parkings);
      },
      // defining the shape
      shape: RoundedRectangleBorder(


        // side: BorderSide(
        //     color: Colors.black
        // ),
          borderRadius: BorderRadius.circular(50)

      ),
      child: const Text(

        "Print",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,

        ),
      ),
    ),



        ],
      ),





      onTap: () {

        // var route = new MaterialPageRoute(
        //   builder: (BuildContext context) =>
        //   new reportDetails(value: parkings),
        // );
        // Navigator.of(context).push(route);

      });

}

const Channel = MethodChannel('com.example.native');
const platform = MethodChannel('samples.flutter.dev/battery');

String _batteryLevel = 'Unknown battery level.';



_showToast(Parking parkings) async {
  final String showtoast = await Channel.invokeMethod('showtoast',<String,String>{

    'PlateNumber':parkings.PlateNumber,
    'ParkingAreaName':parkings.ParkingAreaName,
    'ParkingSpotName':parkings.ParkingSpotName,
    'Amount':parkings.Amount,
    'ParkingTime':parkings.ParkingTime,
    'ExpiringTime':parkings.ExpiringTime,
    'qrcode':parkings.qrcode
  });

}





printTicket(Parking parkings) async{


  Uint8List byte = await _getImageFromAsset('assets/LASPAwhite.png');
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

  await SunmiPrinter.printText('Plate Number: ' + parkings.PlateNumber, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  await SunmiPrinter.printText('Parking Area: ' + parkings.ParkingAreaName, style: SunmiStyle(align: SunmiPrintAlign.CENTER));

  await SunmiPrinter.printText('Parking Spot: ' + parkings.ParkingSpotName, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  // await SunmiPrinter.printText('Phone Number' + "phonenumber", style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  await SunmiPrinter.printText("Amount: "+ " ₦ "+ parkings.Amount, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  await SunmiPrinter.printText("Park Time: " + parkings.ParkingTime, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  await SunmiPrinter.printText("End Time: " + parkings.ExpiringTime, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  // await SunmiPrinter.printText('Using the old way to bold!');
  await SunmiPrinter.line();

  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Name', width: 2, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: 'Qty', width: 2, align: SunmiPrintAlign.CENTER)
  ]);



  await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  // await SunmiPrinter.line();
  // await SunmiPrinter.bold();
  // await SunmiPrinter.printText('Transaction\'s Qrcode');
  await SunmiPrinter.resetBold();
  await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER) ;
  // await SunmiPrinter.printQRCode('https://app.prananet.io/LaspaApp/Qrcode/qrcodes/005_file_4d64df3bbeb6d72d8751596857feed95.png');
  String url = 'https://app.prananet.io/LaspaApp/Qrcode/QRImage.png';
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

Future<Uint8List> readFileBytes(String path) async {
  ByteData fileData = await rootBundle.load(path);
  Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  return fileUnit8List;
}

Future<Uint8List> _getImageFromAsset(String iconPath) async {
  return await readFileBytes(iconPath);
}



// class reportDetails extends StatefulWidget {
//   final Parking value;
//   // const reportDetails({Key? key,this.value}) : super(key: key);
//   reportDetails({Key? key, required this.value}) : super(key: key);
//
//   @override
//   _reportDetailsState createState() => _reportDetailsState();
// }
//
// class _reportDetailsState extends State<reportDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffD8D8D8),
//       appBar: new AppBar(
//         backgroundColor: Color(0xffffcc00),
//         centerTitle: false,
//         title: Center(
//             child: Text(
//               "Parking Information",
//               style: TextStyle(
//                 color: Color(0xff000000),
//               ),
//             )),
//         elevation: 0,
//       ),
//
//       body: SingleChildScrollView(
//         child: Container(
//
//           color: Color(0xffffffff),
//           child: Column(
//             children: <Widget>[
//
//
//               SizedBox(
//                 height: 10,
//               ),
//               Center(child: Text('Customer Parking Information',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//
//               )),
//
//               SizedBox(
//                 height: 30,
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Plate Number',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.PlateNumber}',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//
//
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Hours',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.ParkingHour}',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Start Time',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.ParkingTime}',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Expiring Time',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.ExpiringTime}',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Amount Paid',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.Amount}',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Payment Method',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.channel}',
//                           // textDirection: TextDirection.LTR,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Location',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           ' ${widget.value.Location}',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//
//
//
//               Divider(
//                   color: Colors.black
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       'Phone Number',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: Text(
//                           '*********',
//                           // textDirection: TextDirection.ltr,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ))
//                   ],
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: MaterialButton(
//                   minWidth: double.infinity,
//                   height: 60,
//                   onPressed: () async {
//
//                   },
//                   color: Color(0xffffcc00),
//
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//
//                   ),
//                   child: Text(
//                     "Notify", style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18,
//                     color: Colors.black,
//
//                   ),
//                   ),
//
//                 ),
//               ),
//
//
//
//             ],   ),
//         ),
//       ),
//     );
//   }
// }

//Future is n object representing a delayed computation.


