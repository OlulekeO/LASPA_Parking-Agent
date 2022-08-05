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


class Parking {
  final String ParkingID,AgentID,ExpiringTime,ParkingTime,ParkingAreaID,ParkingSpotID,qrcode,ParkingAreaName,ParkingSpotName;
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
      qrcode: Apis.QrcodeLocationAlt + "QRImage.png",
      ParkingAreaName:jsonData['ParkingAreaName'],
      ParkingSpotName:jsonData['ParkingSpotName'],






    );
  }
}

late final List<Parking> parkings;

class card_payment extends StatefulWidget {
  const card_payment({Key? key}) : super(key: key);

  @override
  _card_paymentState createState() => _card_paymentState();
}
DateTime datetime = DateTime.now();
class _card_paymentState extends State<card_payment> {

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

  String channel = 'Card (Agent)';

  String parkingspotid = '';
  String datetime3 = DateFormat.MMMMEEEEd().format(datetime);




  static const Channel = MethodChannel('com.example.native');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';


  _showToast(Parking parking) async {


    final String showtoast = await Channel.invokeMethod('CardPayment',<String,String>{
      'PlateNumber':parking.PlateNumber,
      'ParkingAreaName':parking.ParkingAreaName,
      'ParkingSpotName':parking.ParkingSpotName,
      'Amount':parking.Amount,
      'ParkingTime':parking.ParkingTime,
      'ExpiringTime':parking.ExpiringTime,
      'qrcode':parking.qrcode,
      'ParkingID':parking.ParkingID
    });

  }

  Future<List<Parking>> customerCardPayment() async {
    String url = Apis.CustomerParkingCreateCard;


    final response = await http.post(url, body: {
      "phonenumber": phonenumber,
      "duration": dropdownStrHours,
      "AgentID": AgentID,
      "PlateNumber": platenumber,
      "channel": channel,
      "parkingspotid": parkingspotid,

    });


    var responseData = json.decode(response.body);
    print(responseData);
    // Map message = jsonDecode(responseData);
    // String name = message['firstname'];
    // print (name);
    // print(message);
    // Map<String, dynamic> LoginResponse = jsonDecode(response.body);
    if (responseData != ''){

      List<Parking> parkings = [];
      for (var jsonData in responseData) {
        Parking parking = Parking(
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
            qrcode: Apis.QrcodeLocationAlt1 + jsonData['Qrimage'],
            ParkingAreaName:jsonData['ParkingAreaName'],
            ParkingSpotName:jsonData['ParkingSpotName']);

        //Adding user to the list.
        parkings.add(parking);
        _showToast(parking);
      }
      return parkings;





    }else{

      setState(() {
      });
      String message = "Parking Lane booked";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(message),
            actions: <Widget>[
              FlatButton(
                child:  Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );



    }

    // if(responseData!=''){
    //
    // }
    //
    // else{
    //
    // }
    return parkings;
    // Creating a list to store input data;


  }



 // customerCardPayment() async {
 //    HttpClient client =  HttpClient();
 //    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
 //
 //    String url = "https://app.prananet.io/LaspaApp/Api/CustomerParkingCreate";
 //
 //
 //    if (dropdownStrHours == 'No of Hours'){
 //      String message = "Choose Duration!!!";
 //      showDialog(
 //        context: context,
 //        builder: (BuildContext context) {
 //          return AlertDialog(
 //            title: Text(message),
 //            actions: <Widget>[
 //              FlatButton(
 //                child: Text("OK"),
 //                onPressed: () {
 //                  Navigator.of(context).pop();
 //                  // Navigator.pushReplacement(
 //                  //     context, MaterialPageRoute(builder: (context) => fee_payment_ussd()));
 //
 //                },
 //              ),
 //            ],
 //          );
 //        },
 //      );
 //
 //    }else{
 //
 //
 //
 //      final response = await http.post(url, body: {
 //        "phonenumber": phonenumber,
 //        "duration": dropdownStrHours,
 //        "AgentID": AgentID,
 //        "PlateNumber": platenumber,
 //        "channel": channel,
 //        "parkingspotid": parkingspotid,
 //
 //      });
 //
 //
 //
 //  //var responseData = json.decode(response.body);
 //      String responseData = json.encode(response.body);
 //      var message = json.decode(responseData);
 //      //print(message);
 //      // print(responseData);
 //
 //
 //  if(message!=''){
 //        print(message);
 //
 //        List<Parking> parking = [];
 //  for (var jsonData in message) {
 //  Parking parking = Parking(
 //  ParkingID: jsonData['ParkingID'],
 //  AgentID: jsonData['AgentID'],
 //  Location: jsonData['Location'],
 //  PlateNumber: jsonData['PlateNumber'],
 //  ParkingHour: jsonData['ParkingHour'],
 //  ExpiringTime: jsonData['ExpiringTime'],
 //  ParkingTime: jsonData['ParkingTime'],
 //  Parkingstatus: jsonData['Parkingstatus'],
 //  channel:jsonData['channel'],
 //  TrnxRef:jsonData['TrnxRef'],
 //  DateAdded:jsonData['DateAdded'],
 //  DateCreated:jsonData['DateCreated'],
 //  Amount:jsonData['Amount'],
 //  ParkingAreaID:jsonData['ParkingAreaID'],
 //  ParkingSpotID:jsonData['ParkingSpotID'],
 //  qrcode: "https://app.prananet.io/LaspaApp/Qrcode/QRImage.png",
 //  ParkingAreaName:jsonData['ParkingAreaName'],
 //  ParkingSpotName:jsonData['ParkingSpotName']);
 //
 //  //Adding user to the list.
 //  parkings.add(parking);
 //
 //  // localStorage = await SharedPreferences.getInstance();
 //  // localStorage.setString('AgentID',parking.channel);
 //  print("kokook");
 //  print(parking.ExpiringTime);
 //
 //  }
 //  return parkings;
 //
 //
 //        //String img = 'https://app.prananet.io/LaspaApp/Qrcode/QRImage.png';
 //       // _showToast();
 //      }
 //      else{
 //        setState(() {
 //        });
 //        String message = "Something went wrong!!!!!";
 //        showDialog(
 //          context: context,
 //          builder: (BuildContext context) {
 //            return AlertDialog(
 //              title: new Text(message),
 //              actions: <Widget>[
 //                FlatButton(
 //                  child: new Text("OK"),
 //                  onPressed: () {
 //                    Navigator.of(context).pop();
 //                  },
 //                ),
 //              ],
 //            );
 //          },
 //        );
 //      }
 //      return parkings;
 //
 //    }
 //
 //
 //  }




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
    HttpClient client = HttpClient();
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
                      const Text("Pay with Card",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                        hint: const Text("Choose duration"),
                        isExpanded: true,
                        value: dropdownStrHours,
                        icon: Icon(Icons.arrow_drop_down),
                        iconEnabledColor: Colors.redAccent,
                        iconSize: 30,
                        style: const TextStyle(
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

                              customerCardPayment();
                            }

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => code_generation()));
                          },
                          color: const Color(0xffffcc00),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Continue",
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

