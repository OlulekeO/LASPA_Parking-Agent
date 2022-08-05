import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'user_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:http/http.dart' as http;
import '../Landing.dart';
import 'ExpiredParkingCustomer.dart';
import 'WarningParkingCustomer.dart';
import 'parkedcarsInformation.dart';
import 'Transactions.dart';
import 'VendedTransactions.dart';
import 'constants.dart';


late SharedPreferences localStorage;

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
DateTime datetime = DateTime.now();
class _HomePageState extends State<Transactions> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field  state
  String marshalID = '';
  String ConcID = '1';
  String Location = 'Victoria Island';
  String duration = '';
  String phone = '';
  String platenumber = '';
  String amount = '';

  String pushlinkphone = '';
  String pushlinkplatenumber = '';


  TextEditingController durationController = TextEditingController();
  TextEditingController platenumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();






  _showSimpleModalDialog(context) {
    showDialog(
        context: context,
        barrierDismissible:
        true, // should dialog be dismissed when tapped outside
        barrierLabel: "Modal", // label for barrier

        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: 350),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "USSD Code",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.black,
                                wordSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Alert custom content
  _onAlertWithCustomContentPressed(context) {
    Alert(
      context: context,
      title: "USSD Code",
      buttons: [],
      content: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Phone Number',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Plate Number',
            ),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              // icon: Icon(Icons.lock),
              labelText: 'Duration',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Text(
                ' *737*2*1000£ ',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              MaterialButton(
                // minWidth: double.infinity,
                height: 30,
                color: Color(0xffffcc00),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                // defining the shape
                shape: RoundedRectangleBorder(

                  // side: BorderSide(
                  //     color: Colors.black
                  // ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "PushLink",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).show();
  }

  //alert for pay with card
  _Paywithcard(context) {
    Alert(
      context: context,
      title: "Pay with Card",
      buttons: [],
      content: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Phone Number',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Plate Number',
            ),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              // icon: Icon(Icons.lock),
              labelText: 'Pin',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(

            minWidth: double.infinity,
            height: 40,
            color: Color(0xffffcc00),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));

            },
            // defining the shape
            shape: RoundedRectangleBorder(


              // side: BorderSide(
              //     color: Colors.black
              // ),
                borderRadius: BorderRadius.circular(50)

            ),
            child: Text(

              "Submit",
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

  _ReceiptQrcode(context) {

    Alert(

      context: context,
      // title: "Receipt",
      buttons: [],
      content: Form(
        key:  _formKey,
        child: Column(

          children: <Widget>[
            // SizedBox(
            //   height: 20,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 1.0),
              height: 200,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 90,
                child: Image.asset(
                  "assets/VI.png",
                  height: 600,
                ),
              ),
            ),
            TextField(
              onChanged :(val){
                setState(() => pushlinkphone = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              onChanged :(val){
                setState(() => pushlinkplatenumber = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Plate Number',
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[




                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: MaterialButton(
                      // minWidth: double.infinity,
                      height: 30,
                      color: Color(0xffFFF5CC),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      // defining the shape
                      shape: RoundedRectangleBorder(

                        // side: BorderSide(
                        //     color: Colors.black
                        // ),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "www.Pranpay.com",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(

                  child:  MaterialButton(
                    // minWidth: double.infinity,
                    height: 30,

                    color: Color(0xffffcc00),
                    onPressed: () {
                      paywithpushlinkcreate();
                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(

                      // side: BorderSide(
                      //     color: Colors.black
                      // ),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "PushLink",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

              ],
            ),


          ],
        ),
      ),

    ).show();
  }


  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  String SubMarshalID = '';

  String datetime3 = DateFormat.MMMMEEEEd().format(datetime);


  String channel = 'Cash (Agent)';

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      marshalID = preferences.getString('AgentCode')?? '';
    });
  }



  Future<List<Spacecraft>> AgentTicketCount() async {


    final jsonEndpoint = "https://app.prananet.io/LaspaApp/Api/AgentTicket";

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": marshalID,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts = json.decode(response.body);
      print(spacecrafts);

      return spacecrafts
          .map((spacecraft) => new Spacecraft.fromJson(spacecraft))
          .toList();
    } else
      throw Exception('We were not able to successfully download the json data.');
  }
  Future<List<Spacecraft6>> AgentTicketCount6() async {


    final jsonEndpoint = "https://app.prananet.io/LaspaApp/Api/Agent-detailsGet";

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": marshalID,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts6 = json.decode(response.body);
      print(spacecrafts6);

      return spacecrafts6
          .map((spacecraft6) => new Spacecraft6.fromJson(spacecraft6))
          .toList();
    } else
      throw Exception('We were not able to successfully download the json data.');
  }

  Future<List<Spacecraft1>> downloadJSON1() async {


    final jsonEndpoint = "https://app.prananet.io/LaspaApp/Api/AgentTransactionsGetByID";

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": marshalID,
    });

    if (response.statusCode == 200) {
      List spacecrafts1 = json.decode(response.body);
      return spacecrafts1
          .map((spacecraft1) => new Spacecraft1.fromJson(spacecraft1))
          .toList();
    } else
      throw Exception('We were not able to successfully download the json data.');
  }
  Future<List<Spacecraft>> downloadJSON() async {




    final jsonEndpoint = "https://app.prananet.io/LaspaApp/Api/AgentTransactionsGetByID";

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": marshalID,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts = json.decode(response.body);
      return spacecrafts
          .map((spacecraft) => new Spacecraft.fromJson(spacecraft))
          .toList();
    } else
      throw Exception('We were not able to successfully download the json data.');
  }
  Future<List<Spacecraft2>> downloadJSON2() async {


    final jsonEndpoint = "https://app.prananet.io/LaspaApp/Api/AgentTransactionsGetByID";

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": marshalID,
    });

    if (response.statusCode == 200) {
      List spacecrafts2 = json.decode(response.body);
      return spacecrafts2
          .map((spacecraft2) => new Spacecraft2.fromJson(spacecraft2))
          .toList();
    } else
      throw Exception('We were not able to successfully download the json data.');
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
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });
      //
      // SunmiPrinter.printerVersion().then((String version) {
      //   setState(() {
      //     printerVersion = version;
      //   });
      // });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }
  //String SubMarshalID1 = '3';




  _Paywithcash(context) {
    Alert(
      context: context,
      title: "Pay with Cash",
      buttons: [],

      content: Form(
        key:  _formKey,
        child: Column(
          children: <Widget>[

            TextField(
              controller: durationController,
              onChanged :(val){

                setState(() => duration = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Duration',

              ),
            ),
            TextField(
              controller: platenumberController,
              onChanged :(val){

                setState(() => platenumber = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Plate Number',
              ),
            ),
            TextField(
              controller: phonenumberController,
              onChanged :(val){

                setState(() => phone = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Phone Number',

              ),
            ),
            TextField(
              controller: amountController,
              onChanged :(val){

                setState(() => amount = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Amount',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Center(
            //     child: Container(
            //       width: double.infinity,
            //       height: 50,
            //       child: RaisedButton(
            //         elevation: 2.0,
            //         onPressed: () {
            //           paywithcashcreate();
            //         },
            //         color: Colors.green,
            //         shape: new RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(10.0),
            //         ),
            //         child: Text(
            //           "Publish",
            //           style: TextStyle(color: Colors.white, fontSize: 18),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
            MaterialButton(

              minWidth: double.infinity,
              height: 40,
              color: Color(0xffffcc00),
              onPressed: () {
                paywithcashcreate();
                _ReceiptFinal(context);

              },
              // defining the shape
              shape: RoundedRectangleBorder(


                // side: BorderSide(
                //     color: Colors.black
                // ),
                  borderRadius: BorderRadius.circular(50)

              ),
              child: Text(

                "Submit",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,

                ),
              ),
            ),
          ],
        ),
      ),

    ).show();
  }

  printTicket() async{


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
    await SunmiPrinter.printText('Phone Number' + phone, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Location' +'Victoria Island', style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Amount' + amount, style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('Using the old way to bold!');
    await SunmiPrinter.line();

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // await SunmiPrinter.line();
    // await SunmiPrinter.bold();
    // await SunmiPrinter.printText('Transaction\'s Qrcode');
    await SunmiPrinter.resetBold();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer');
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




  Future <String>  paywithcashcreate() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = "https://app.prananet.io/LaspaApp/Api/CustomerParkingCreate";
    final response = await http.post(url, body: {
      "MashalID": marshalID,
      "ConcID": ConcID,
      "Amount": amount,
      "Location": Location,
      "PlateNumber": platenumber,
      "duration": duration,
      "channel": channel,
    });
    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    //print(message);


    if(message.contains("Successful")){
      print(message);
      // localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('AgentCode',marshalID);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Landing()));


    }
    else{
      String message = json.decode(responseData);
      print(message);
      // setState(() {
      // });
      // String message = "Error Adding";
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: new Text(message),
      //       actions: <Widget>[
      //         FlatButton(
      //           child: new Text("OK"),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
    return message;
  }

  Future <String>  paywithpushlinkcreate() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = "https://app.prananet.io/LaspaApp/Api/CustomerPushLinkPayment";
    final response = await http.post(url, body: {
      "MashalID": marshalID,
      "pushlinkphone": pushlinkphone,
      "Location": 'Victoria Island',
      "PlateNumber": platenumber,
    });
    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    //print(message);


    if(message.contains("Good")){
      String message = "Message on its way";
      print(message);
      setState(() {
      });

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

    }
    else{
      String message = json.decode(responseData);
      print(message);
      // setState(() {
      // });
      // String message = "Error Adding";
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: new Text(message),
      //       actions: <Widget>[
      //         FlatButton(
      //           child: new Text("OK"),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
    return message;
  }


  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  _ReceiptFinal(context) {
    Alert(
      context: context,
      title: "Receipt",
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
            ' Payment Successful',
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
                height: 200,


                child: new Column(


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
                        Image.asset(
                          "assets/Icon metro-qrcode-1.png",
                          height: 100,
                        ),

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
                                child: Text(phone,
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
          //     printTicket();
          //     setState(() {
          //       Transactions();
          //       HomePage();
          //
          //     });
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
          //   child: Text(
          //
          //     "Print",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w600,
          //       fontSize: 18,
          //
          //     ),
          //   ),
          // ),
        ],
      ),

    ).show();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffD8D8D8),
        appBar: new AppBar(
          backgroundColor: Color(0xffffcc00),
          centerTitle: false,
          title: Center(
              child: Text(
                "Home",
                style: TextStyle(
                  color: Color(0xff000000),
                ),
              )),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(

                  padding: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 7,
                  ),
                  height: 150,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),


                  child: new Column(
                    children: [
                      SafeArea(

                        child: new FutureBuilder<List<Spacecraft6>>(
                          future: AgentTicketCount6(),
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          builder: (context, snapshot) {


                            if (snapshot.hasData) {
                              List<Spacecraft6>? spacecrafts6 = snapshot.data;
                              return new CustomListView6(spacecrafts6!);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                              return Text('No Report Yet');
                            }
                            //return  a circular progress indicator.
                            return new CircularProgressIndicator();


                          },

                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: const <Widget>[
                                Expanded(
                                  child: Text('Available Space',
                                      textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: Text('Total Cars Parked ',
                                      textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: Text('Cars Parked',
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            ),



                            SafeArea(

                              child: new FutureBuilder<List<Spacecraft>>(
                                future: AgentTicketCount(),
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                builder: (context, snapshot) {


                                  if (snapshot.hasData) {
                                    List<Spacecraft>? spacecrafts = snapshot.data;
                                    return new CustomListView(spacecrafts!);
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                    return Text('No Report Yet');
                                  }
                                  //return  a circular progress indicator.
                                  return new CircularProgressIndicator();


                                },

                              ),
                            ),



                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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


                          ColoredBox(

                            color:Color(0xff2E2F39),
                            child: TabBar(
                              // overlayColor:Color(0xff2E2F39),
                              indicatorColor: Color(0xffD8D8D8),


                              tabs: [
                                Tab(

                                  icon: ImageIcon(
                                    AssetImage('assets/green1.png'),
                                    color: Color(0xFF00D358),
                                  ),


                                ),
                                Tab(
                                  icon: ImageIcon(
                                    AssetImage("assets/Yellow.png"),
                                    color: Color(0xffFEE01D),
                                  ),

                                ),
                                Tab(
                                  icon: ImageIcon(
                                    AssetImage("assets/Red.png"),
                                    color: Color(0xffFF000A),
                                  ),

                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 800,
                            child: TabBarView(
                              physics: BouncingScrollPhysics(),

                              children: [

                                SafeArea(

                                  child: new FutureBuilder<List<Spacecraft1>>(
                                    future: downloadJSON1(),
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    builder: (context, snapshot) {


                                      if (snapshot.hasData) {
                                        List<Spacecraft1>? spacecrafts1 = snapshot.data;
                                        return SizedBox(
                                            height: MediaQuery.of(context).size.height,
                                            child: new CustomListView1(spacecrafts1!));
                                      } else if (snapshot.hasError) {
                                        return Container(

                                            child: Text('No Transaction'));
                                        return Text('No Report Yet');
                                      }
                                      //return  a circular progress indicator.
                                      return new CircularProgressIndicator();


                                    },
                                    // children: <Widget>[
                                    //   Container(
                                    //     padding: EdgeInsets.only(
                                    //       left: kDefaultPadding,
                                    //       right: kDefaultPadding,
                                    //       bottom: 11,
                                    //     ),
                                    //     height: 150,
                                    //     decoration: BoxDecoration(
                                    //       color: kPrimaryColor,
                                    //       borderRadius: BorderRadius.only(
                                    //         bottomLeft: Radius.circular(36),
                                    //         bottomRight: Radius.circular(36),
                                    //       ),
                                    //     ),
                                    //     child: new Column(
                                    //       children: [
                                    //         Row(
                                    //           mainAxisSize: MainAxisSize.min,
                                    //           children: <Widget>[
                                    //             Image.asset(
                                    //               "assets/LASPAo.png",
                                    //               height: 70,
                                    //             ),
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(8.0),
                                    //               child: Text(
                                    //                 'Good Afternoon,  \n Leke',
                                    //
                                    //                 style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                                    //               ),
                                    //             ),
                                    //
                                    //             Spacer(),
                                    //             Image.asset("assets/Transaction.png"),
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(8.0),
                                    //               child: Image.asset(
                                    //                   "assets/Icon ionic-ios-notifications-outline.png"),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //
                                    //         SizedBox(
                                    //           height: 20,
                                    //         ),
                                    //         Container(
                                    //           margin: const EdgeInsets.only(bottom: 5.0),
                                    //           child: Column(
                                    //             children: [
                                    //               Row(
                                    //                 children: const <Widget>[
                                    //                   Expanded(
                                    //                     child: Text('Available Space',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('Total Cars Parked ',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('Cars Parked',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               Row(
                                    //                 children: const <Widget>[
                                    //                   Expanded(
                                    //                     child: Text('120 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('90 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('76 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //
                                    //   //tab view will be here ooo
                                    //   SizedBox(
                                    //     height: 50,
                                    //     child: AppBar(
                                    //       backgroundColor: Color(0xffffffff),
                                    //       bottom: TabBar(
                                    //         indicatorColor: Color(0xffD8D8D8),
                                    //
                                    //
                                    //         tabs: [
                                    //           Tab(
                                    //
                                    //             icon: ImageIcon(
                                    //               AssetImage('assets/green1.png'),
                                    //               color: Color(0xFF00D358),
                                    //             ),
                                    //
                                    //
                                    //           ),
                                    //           Tab(
                                    //             icon: ImageIcon(
                                    //               AssetImage("assets/Yellow.png"),
                                    //               color: Color(0xffFEE01D),
                                    //             ),
                                    //
                                    //           ),
                                    //           Tab(
                                    //             icon: ImageIcon(
                                    //               AssetImage("assets/Red.png"),
                                    //               color: Color(0xffFF000A),
                                    //             ),
                                    //
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    //
                                    //   // create widgets for each tab bar here
                                    //   Expanded(
                                    //     child: TabBarView(
                                    //       children: [
                                    //         // first tab bar view widget
                                    //         // createViewItem(),
                                    //
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         // second tab bar viiew widget
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "Expired",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "Expired",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //
                                    //
                                    //
                                    //
                                    //
                                    //
                                    // ],
                                  ),
                                ),

                                SafeArea(

                                  child: new FutureBuilder<List<Spacecraft1>>(
                                    future: downloadJSON1(),
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    builder: (context, snapshot) {


                                      if (snapshot.hasData) {
                                        List<Spacecraft1>? spacecrafts1 = snapshot.data;
                                        return SizedBox(
                                            height: MediaQuery.of(context).size.height,
                                            child: new CustomListView1(spacecrafts1!));
                                      } else if (snapshot.hasError) {
                                        return Container(

                                            child: Text('No Transaction'));
                                        return Text('No Report Yet');
                                      }
                                      //return  a circular progress indicator.
                                      return new CircularProgressIndicator();


                                    },
                                    // children: <Widget>[
                                    //   Container(
                                    //     padding: EdgeInsets.only(
                                    //       left: kDefaultPadding,
                                    //       right: kDefaultPadding,
                                    //       bottom: 11,
                                    //     ),
                                    //     height: 150,
                                    //     decoration: BoxDecoration(
                                    //       color: kPrimaryColor,
                                    //       borderRadius: BorderRadius.only(
                                    //         bottomLeft: Radius.circular(36),
                                    //         bottomRight: Radius.circular(36),
                                    //       ),
                                    //     ),
                                    //     child: new Column(
                                    //       children: [
                                    //         Row(
                                    //           mainAxisSize: MainAxisSize.min,
                                    //           children: <Widget>[
                                    //             Image.asset(
                                    //               "assets/LASPAo.png",
                                    //               height: 70,
                                    //             ),
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(8.0),
                                    //               child: Text(
                                    //                 'Good Afternoon,  \n Leke',
                                    //
                                    //                 style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                                    //               ),
                                    //             ),
                                    //
                                    //             Spacer(),
                                    //             Image.asset("assets/Transaction.png"),
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(8.0),
                                    //               child: Image.asset(
                                    //                   "assets/Icon ionic-ios-notifications-outline.png"),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //
                                    //         SizedBox(
                                    //           height: 20,
                                    //         ),
                                    //         Container(
                                    //           margin: const EdgeInsets.only(bottom: 5.0),
                                    //           child: Column(
                                    //             children: [
                                    //               Row(
                                    //                 children: const <Widget>[
                                    //                   Expanded(
                                    //                     child: Text('Available Space',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('Total Cars Parked ',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('Cars Parked',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               Row(
                                    //                 children: const <Widget>[
                                    //                   Expanded(
                                    //                     child: Text('120 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('90 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('76 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //
                                    //   //tab view will be here ooo
                                    //   SizedBox(
                                    //     height: 50,
                                    //     child: AppBar(
                                    //       backgroundColor: Color(0xffffffff),
                                    //       bottom: TabBar(
                                    //         indicatorColor: Color(0xffD8D8D8),
                                    //
                                    //
                                    //         tabs: [
                                    //           Tab(
                                    //
                                    //             icon: ImageIcon(
                                    //               AssetImage('assets/green1.png'),
                                    //               color: Color(0xFF00D358),
                                    //             ),
                                    //
                                    //
                                    //           ),
                                    //           Tab(
                                    //             icon: ImageIcon(
                                    //               AssetImage("assets/Yellow.png"),
                                    //               color: Color(0xffFEE01D),
                                    //             ),
                                    //
                                    //           ),
                                    //           Tab(
                                    //             icon: ImageIcon(
                                    //               AssetImage("assets/Red.png"),
                                    //               color: Color(0xffFF000A),
                                    //             ),
                                    //
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    //
                                    //   // create widgets for each tab bar here
                                    //   Expanded(
                                    //     child: TabBarView(
                                    //       children: [
                                    //         // first tab bar view widget
                                    //         // createViewItem(),
                                    //
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         // second tab bar viiew widget
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "Expired",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "Expired",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //
                                    //
                                    //
                                    //
                                    //
                                    //
                                    // ],
                                  ),
                                ),



                                SafeArea(

                                  child: new FutureBuilder<List<Spacecraft2>>(
                                    future: downloadJSON2(),
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    builder: (context, snapshot) {


                                      if (snapshot.hasData) {
                                        List<Spacecraft2>? spacecrafts2 = snapshot.data;
                                        return SizedBox(
                                            height: MediaQuery.of(context).size.height,
                                            child: new CustomListView2(spacecrafts2!));
                                      } else if (snapshot.hasError) {
                                        return Container(

                                            child: Text('No Transaction'));
                                        return Text('No Report Yet');
                                      }
                                      //return  a circular progress indicator.
                                      return new CircularProgressIndicator();


                                    },
                                    // children: <Widget>[
                                    //   Container(
                                    //     padding: EdgeInsets.only(
                                    //       left: kDefaultPadding,
                                    //       right: kDefaultPadding,
                                    //       bottom: 11,
                                    //     ),
                                    //     height: 150,
                                    //     decoration: BoxDecoration(
                                    //       color: kPrimaryColor,
                                    //       borderRadius: BorderRadius.only(
                                    //         bottomLeft: Radius.circular(36),
                                    //         bottomRight: Radius.circular(36),
                                    //       ),
                                    //     ),
                                    //     child: new Column(
                                    //       children: [
                                    //         Row(
                                    //           mainAxisSize: MainAxisSize.min,
                                    //           children: <Widget>[
                                    //             Image.asset(
                                    //               "assets/LASPAo.png",
                                    //               height: 70,
                                    //             ),
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(8.0),
                                    //               child: Text(
                                    //                 'Good Afternoon,  \n Leke',
                                    //
                                    //                 style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                                    //               ),
                                    //             ),
                                    //
                                    //             Spacer(),
                                    //             Image.asset("assets/Transaction.png"),
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(8.0),
                                    //               child: Image.asset(
                                    //                   "assets/Icon ionic-ios-notifications-outline.png"),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //
                                    //         SizedBox(
                                    //           height: 20,
                                    //         ),
                                    //         Container(
                                    //           margin: const EdgeInsets.only(bottom: 5.0),
                                    //           child: Column(
                                    //             children: [
                                    //               Row(
                                    //                 children: const <Widget>[
                                    //                   Expanded(
                                    //                     child: Text('Available Space',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('Total Cars Parked ',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('Cars Parked',
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               Row(
                                    //                 children: const <Widget>[
                                    //                   Expanded(
                                    //                     child: Text('120 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('90 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                   Expanded(
                                    //                     child: Text('76 ',
                                    //                         style: TextStyle(
                                    //                           fontWeight: FontWeight.w900,
                                    //                           fontSize: 24,
                                    //                         ),
                                    //                         textAlign: TextAlign.center),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //
                                    //   //tab view will be here ooo
                                    //   SizedBox(
                                    //     height: 50,
                                    //     child: AppBar(
                                    //       backgroundColor: Color(0xffffffff),
                                    //       bottom: TabBar(
                                    //         indicatorColor: Color(0xffD8D8D8),
                                    //
                                    //
                                    //         tabs: [
                                    //           Tab(
                                    //
                                    //             icon: ImageIcon(
                                    //               AssetImage('assets/green1.png'),
                                    //               color: Color(0xFF00D358),
                                    //             ),
                                    //
                                    //
                                    //           ),
                                    //           Tab(
                                    //             icon: ImageIcon(
                                    //               AssetImage("assets/Yellow.png"),
                                    //               color: Color(0xffFEE01D),
                                    //             ),
                                    //
                                    //           ),
                                    //           Tab(
                                    //             icon: ImageIcon(
                                    //               AssetImage("assets/Red.png"),
                                    //               color: Color(0xffFF000A),
                                    //             ),
                                    //
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    //
                                    //   // create widgets for each tab bar here
                                    //   Expanded(
                                    //     child: TabBarView(
                                    //       children: [
                                    //         // first tab bar view widget
                                    //         // createViewItem(),
                                    //
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         // second tab bar viiew widget
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "2hrs left",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //           color: Color(0xffD8D8D8),
                                    //           child: Center(
                                    //             child: Column(
                                    //               children: [
                                    //                 // Text(
                                    //                 //   'Bike',
                                    //                 // ),
                                    //                 SizedBox(
                                    //                   height: 20,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "Expired",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   height: 10,
                                    //                 ),
                                    //                 Padding(
                                    //                   padding: const EdgeInsets.all(8.0),
                                    //                   child: Container(
                                    //                     height: 60,
                                    //
                                    //                     decoration: BoxDecoration(
                                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    //                       color: Color(0xffD8D8D8),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                           color: Color(0xffffffff),
                                    //                           offset: Offset(0.0, 1.0), //(x,y)
                                    //                           blurRadius: 5.0,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                     // color: Color(0xffD8D8D8),
                                    //                     child: Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                       children: [
                                    //
                                    //
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "IKJ-354TY",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(2.0),
                                    //                           child:    Text(
                                    //                             "2:10pm",
                                    //                           ),
                                    //
                                    //                         ),
                                    //                         Padding(
                                    //                           padding: const EdgeInsets.all(8.0),
                                    //                           child:    Text(
                                    //                             "Expired",
                                    //                           ),
                                    //                         ),
                                    //                         Image.asset("assets/Transaction.png"),
                                    //
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //
                                    //
                                    //
                                    //
                                    //
                                    //
                                    // ],
                                  ),
                                ),
                              ],

                            ),
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