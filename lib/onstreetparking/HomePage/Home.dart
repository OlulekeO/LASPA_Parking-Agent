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
import '../../onstreetparking/modal_screens/cash_pay.dart';
import '../../onstreetparking/modal_screens/ussd_pay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:http/http.dart' as http;
import 'package:sunmi_printer_plus/sunmi_style.dart';
import '../../Landing.dart';
import '../AgentTicketInformation.dart';
import '../Transactions.dart';
import '../VendedTransactions.dart';
import '../constants.dart';
import '../modal_screens/card_pay.dart';
import '../modal_screens/qr_scanner.dart';
import '../../onstreetparking/OnStreetLanding.dart';

String GeneratedUSSDCode ='';
late SharedPreferences localStorage;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
DateTime datetime = DateTime.now();
class _HomePageState extends State<HomePage> {

  static const Channel = MethodChannel('com.example.native');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  final String _batteryLevel = 'Unknown battery level.';

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
String ParkingAreaID = '';
  // text field  state
  String AgentCode = '';
  // String ConcID = '1';
  String Location = '';
  String duration = '';
  String phone = '';
  String platenumber = '';
  String amount = '';

  String pushlinkphone = '';
  String pushlinkplatenumber = '';


  String ussdbank = '';
  String ussdplatenumber = '';
  String ussdamount = '';

  String customerEmail = '';


  TextEditingController durationController = TextEditingController();
  TextEditingController platenumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();


  List<String> property = [
    'GTB', 'herit', 'WEMA','UNION'

  ];

  String dropdownStr =  'GTB';

  String dropdownStrHours = 'No of Hours';

  List<String> hours = [
    'No of Hours', '1', '2','3','4'

  ];

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
                        text: const TextSpan(
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

  Future<void> _showToast1() async {
    final String showtoast = await Channel.invokeMethod('OnlinePayment',<String,String>{
      'Amount':"500"
    });

  }



  //alert for pay with card
  _Paywithcard(context) {
    Alert(
      context: context,
      title: "Pay with Card",
      buttons: [],
      content: Form(
        key:  _formKey,
        child: Column(
          children: <Widget>[
            const TextField(

              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Phone Number',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Plate Number',
              ),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Pin',
              ),
            ),
            const SizedBox(
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
      ),

    ).show();
  }



  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  String AgentID = '';
  String FirstName = '';
  String LastName = '';

  String datetime3 = DateFormat.MMMMEEEEd().format(datetime);


  String channel = 'Cash (Agent)';

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentCode = preferences.getString('AgentCode')?? '';
      AgentID = preferences.getString('AgentID')?? '';
      ParkingAreaID = preferences.getString('ParkingAreaID')?? '';
      FirstName = preferences.getString('FirstName')?? '';
      LastName = preferences.getString('LastName')?? '';

    });
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
                child:
                Image.network(Apis.QrcodeLocation+ParkingAreaID+'.png',
                  height: 600,
                ),
                // Image.asset(
                //   "assets/VI.png",
                //   height: 600,
                // ),
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
                setState(() => customerEmail = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Email',
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
                      child:  Text(
                        Apis.basesalt +'?i='+ParkingAreaID,


                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
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

                    color: const Color(0xffffcc00),
                    onPressed: () {
                      paywithpushlinkcreate();
                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(

                      // side: BorderSide(
                      //     color: Colors.black
                      // ),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
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


  Future<List<Spacecraft>> AgentTicketCount() async {


      const jsonEndpoint = Apis.AgentTicketGet;

    final response = await http.post(jsonEndpoint, body: {
      "AgentID": AgentID,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts = json.decode(response.body);
      // print(spacecrafts);

      return spacecrafts
          .map((spacecraft) => new Spacecraft.fromJson(spacecraft))
          .toList();
    } else {
      throw Exception('');
    }
  }
  Future<List<Spacecraft6>> AgentTicketCount6() async {
    const jsonEndpoint = Apis.AgentGetDetails;
  
    final response = await http.post(jsonEndpoint, body: {
      "AgentID": AgentID,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts6 = json.decode(response.body);
      // print(spacecrafts6);

      return spacecrafts6
          .map((spacecraft6) =>  Spacecraft6.fromJson(spacecraft6))
          .toList();
    } else
      throw Exception('');
  }
  late GlobalKey<ScaffoldState> _scaffoldKey;


  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      AgentCode = localStorage.getString('AgentCode')?? '';
      AgentID = localStorage.getString('AgentID')?? '';
    });
  }
  @override

  void initState() {
    super.initState();
    getEmail();
    Codegenerate();
    _scaffoldKey = GlobalKey();
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

            // TextField(
            //   controller: durationController,
            //   onChanged :(val){
            //
            //     setState(() => duration = val);
            //   },
            //   decoration: InputDecoration(
            //     // icon: Icon(Icons.account_circle),
            //     labelText: 'Duration',
            //
            //   ),
            // ),
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
            // TextField(
            //   controller: amountController,
            //   onChanged :(val){
            //
            //     setState(() => amount = val);
            //   },
            //   decoration: InputDecoration(
            //     // icon: Icon(Icons.lock),
            //     labelText: 'Amount',
            //   ),
            // ),
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
              //  _ReceiptFinal(context);

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
    await SunmiPrinter.printQRCode('https://ibb.co/KwMZKGz');
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


  Future <String>  paywithussd() async {
    HttpClient client =  HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.USSDcodegenerate;
    final response = await http.post(url, body: {
      "AgentID": AgentID,
      "bank": ussdbank,
      "amount": ussdamount,
      "plateNumber": ussdplatenumber,
    });
    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    print(message);
    localStorage = await SharedPreferences.getInstance();
    localStorage.setString('GeneratedUSSDCode',message);



    Codegenerate();
    _loadCounter();
    generatedussdmodal(context);
    return message;
  }
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      GeneratedUSSDCode = (prefs.getString('GeneratedUSSDCode'))?? '';
    });

    print(GeneratedUSSDCode);
  }

  String codegene = '';

  Codegenerate()async {

    setState(() {
      if(ussdbank == 'GTB'){
        late String rand = '';
        var rng = new Random();
        rand = (rng.nextInt(90000) + 10000) as String;

         codegene = '*737*000*950+'+rand;
        print (codegene);
       // return codegene;
      }
    });
}

  // Alert custom content leke
  _onAlertWithCustomContentPressed(context) {
    Alert(
      context: context,
      title: "USSD Code",
      buttons: [],
      content: Form(
        key:  _formKey,
        child: Column(
          children: <Widget>[

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

            DropdownButton(
              focusColor: Colors.redAccent,
              hint: const Text("Choose Bank"),
              isExpanded: true,
              value: dropdownStr,
              icon: Icon(Icons.arrow_drop_down),
              iconEnabledColor: Colors.redAccent,
              iconSize: 30,
              style: TextStyle(
                color: Colors.black,
              ),
              onChanged: (val) {
                setState(() => dropdownStr);
              },
              items: property
                  .map<DropdownMenuItem<String>> ((String value){
                return DropdownMenuItem<String> (
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            TextField(
              onChanged :(val){
                setState(() => ussdbank = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Bank',
              ),
            ),
            TextField(
              onChanged :(val){
                setState(() => ussdplatenumber = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'PlateNumber',
              ),
            ),
            TextField(
              onChanged :(val){
                setState(() => ussdamount = val);
              },
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Amount',
              ),
            ),
            // TextField(
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     // icon: Icon(Icons.lock),
            //     labelText: 'Duration',
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                const Text(
                  ' *737*2*1000',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                MaterialButton(
                  // minWidth: double.infinity,
                  height: 30,
                  color: Color(0xffffcc00),
                  onPressed: () {
                    paywithussd();

                    Codegenerate();
                   // String message = "Ussd code on its way";
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: new Text(GeneratedUSSDCode),
                    //       actions: <Widget>[
                    //         FlatButton(
                    //           child: new Text(GeneratedUSSDCode),
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );


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
      ),
    ).show();
  }


  Future <String>  paywithcashcreate() async {
    HttpClient client =  HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.CustomerParkingCreate;
    final response = await http.post(url, body: {
      "AgentID": AgentID,
      "ConcID": 1,
      "Location": Location,
      "PlateNumber": platenumber,
      "duration": '1',
      "channel": channel,
    });
    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    //print(message);


    if(message.contains("Successful")){
      print(message);
      _ReceiptFinal(context);
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
    HttpClient client =  HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.CustomerPushLinkPayment;
    final response = await http.post(url, body: {
      "AgentID": AgentID,
      "pushlinkphone": pushlinkphone,
      "customerEmail": customerEmail,
    });
    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    //print(message);


    if(message.contains("successful")){
      String message = "Message sent successfully";
      print(message);
      setState(() {
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                child:  Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                  // redirect o home page
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

  generatedussdmodal(context) {
    Alert(
      context: context,
      title: "USSD CODE ",
      buttons: [],
      content: Column(
        children: <Widget>[
          const SizedBox(
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
            ' Code Generated Successfully',
            style: TextStyle(color: Colors.green, fontSize: 16.0),
          ),

          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Center(
                child: Text(
              codegene,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),

            ],
          ),




          SizedBox(
            height: 10,
          ),

          MaterialButton(

            minWidth: double.infinity,
            height: 40,
            color: Color(0xffffcc00),
            onPressed: () async {
              printTicket();
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

              "Push Link",
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

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }


  void scanCode() async {
    // String res = await FlutterBarcodeScanner.scanBarcode(
    //     "#ffffff", 'Cancel', true, ScanMode.QR);

    print('yes');

    // setState(() {
    //   qrcodeRes = res;
    // });
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


                child:  Column(


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
          MaterialButton(

            minWidth: double.infinity,
            height: 40,
            color: Color(0xffffcc00),
            onPressed: () async {
              printTicket();
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

    ).show();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      appBar:  AppBar(
        backgroundColor: Color(0xffffcc00),
        centerTitle: false,
        title: const Center(
            child: Text(
          "Home",
          style: TextStyle(
            color: Color(0xff000000),
          ),
        )),
        elevation: 0, 
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
                () {
              /// adding elements in list after [1 seconds] delay
              /// to mimic network call
              ///
              /// Remember: [setState] is necessary so that
              /// build method will run again otherwise
              /// list will not show all elements
              setState(() {
                AgentTicketCount6();
              });

              // showing snackbar
              _scaffoldKey.currentState!.showSnackBar(
                const SnackBar(
                  content: Text('Page Refreshed'),
                ),
              );
            },
          );
          AgentTicketCount6();

        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(

                  padding: const EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 7,
                  ),
                  height: 180,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),


                  child: Column(
                    children: [
                      SafeArea(

                        child:  Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  "assets/LASPAo.png",
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Hello, ' + FirstName,

                                    style: const TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VendedTransactions()));


                                    },
                                    child: Image.asset("assets/Transaction.png")),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      "assets/Icon ionic-ios-notifications-outline.png"),
                                ),
                              ],
                            ),


                          ],
                        ),

                        // child: FutureBuilder<List<Spacecraft6>>(
                        //   future: AgentTicketCount6(),
                        //   // mainAxisAlignment: MainAxisAlignment.start,
                        //   // crossAxisAlignment: CrossAxisAlignment.start,
                        //   builder: (context, snapshot) {
                        //
                        //
                        //     if (snapshot.hasData) {
                        //       List<Spacecraft6>? spacecrafts6 = snapshot.data;
                        //       return new CustomListView6(spacecrafts6!);
                        //     } else if (snapshot.hasError) {
                        //       return Text('${snapshot.error}');
                        //       //return Text('0');
                        //      // return Text('No Report Yet');
                        //     }
                        //     //return  a circular progress indicator.
                        //     // return new CircularProgressIndicator();
                        //     return Text('');
                        //
                        //   },
                        //
                        // ),
                      ),




                      SafeArea(

                        child:  FutureBuilder<List<Spacecraft>>(
                          future: AgentTicketCount(),
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          builder: (context, snapshot) {


                            if (snapshot.hasData) {
                              List<Spacecraft>? spacecrafts = snapshot.data;
                              return  CustomListView(spacecrafts!);
                            } else if (snapshot.hasError) {
                              // return Text('${snapshot.error}');
                              return const Text('');
                            }
                            //return  a circular progress indicator.
                            return const CircularProgressIndicator();


                          },

                        ),
                      ),









                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 5.0),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left:50.0, right:50.0),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           children: const <Widget>[
                      //             Expanded(
                      //               child: Text('LASPA CARD ',
                      //                   textAlign: TextAlign.center),
                      //             ),
                      //             Expanded(
                      //               child: Text('RATE ',
                      //                   textAlign: TextAlign.center),
                      //             ),
                      //           ],
                      //         ),
                      //         Row(
                      //           children: const <Widget>[
                      //             Expanded(
                      //               child: Text('₦ 120,000 ',
                      //                   style: TextStyle(
                      //                     fontWeight: FontWeight.w900,
                      //                     fontSize: 16,
                      //                   ),
                      //                   textAlign: TextAlign.center),
                      //             ),
                      //             Expanded(
                      //               child: Text('₦ 900,000 ',
                      //                   style: TextStyle(
                      //                     fontWeight: FontWeight.w900,
                      //                     fontSize: 16,
                      //                   ),
                      //                   textAlign: TextAlign.center),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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

                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: const Color(0xffffffff),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => const ussd_payment()));

                            },


                            // defining the shape
                            shape: RoundedRectangleBorder(

                                // side: BorderSide(
                                //     color: Colors.black
                                // ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "USSD Code",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: const Color(0xffffffff),
                            onPressed: (){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => const card_payment()));
                            },

                            // defining the shape
                            shape: RoundedRectangleBorder(

                                // side: BorderSide(
                                //     color: Colors.black
                                // ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pay with Card",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: const Color(0xffffffff),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => const cash_payment()));

                              // _Paywithcash(context);
                            },
                            // defining the shape
                            shape: RoundedRectangleBorder(

                                // side: BorderSide(
                                //     color: Colors.black
                                // ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pay with Cash",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Color(0xffffffff),
                            onPressed: () {

                              _ReceiptQrcode(context);
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            // defining the shape
                            shape: RoundedRectangleBorder(

                                // side: BorderSide(
                                //     color: Colors.black
                                // ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pay with QR",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: const Color(0xffffffff),
                            onPressed: () {
                              _showToast1();
                            },
                            // defining the shape
                            shape: RoundedRectangleBorder(

                              // side: BorderSide(
                              //     color: Colors.black
                              // ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Settings",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Scan here to pay"),
                          Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[

                                  Expanded(flex: 3,child: Container(padding: const EdgeInsets.only(left:66,top:20),

                                    child:  Image.network(Apis.QrcodeLocation+ParkingAreaID+'.png',
                                      height: 180,
                                      width: 200,
                                    ),

                                  )),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                        const QrScanner()),
                                      );

                                    },
                                    child: Column(
                                      children: [
                                    Container(padding: const EdgeInsets.all(16),

                                            child: const ImageIcon(
                                              AssetImage("assets/scan.png"),
                                              size: 30,
                                              color: Colors.black,
                                            )

                                        ),
                                        const Text(
                                          "Verify Ticket",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   // crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //       child: Image(
                              //         image: AssetImage(
                              //           "assets/VI.png",
                              //         ),
                              //         height: 200,
                              //         width: 200,
                              //       ),
                              //       // This trailing comma makes auto-formatting nicer for build methods.
                              //     ),
                              //     Visibility(
                              //       visible: true,
                              //       child: Padding(
                              //           padding: EdgeInsets.only(right: 10),
                              //           child: ImageIcon(
                              //             AssetImage("assets/scan.png"),
                              //             size: 30,
                              //             color: Colors.white,
                              //           )),
                              //     ),
                              //   ],
                              // ),

                            ],
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