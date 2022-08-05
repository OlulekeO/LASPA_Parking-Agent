import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Apis/api_base.dart';
import 'ParkingCustomersModel/CurrentParkingCustomers.dart';
import 'ParkingCustomersModel/VendedAmount.dart';
import 'VendedTransactions.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendedTransactions extends StatefulWidget {
  const VendedTransactions({Key? key}) : super(key: key);

  @override
  _VendedTransactionsState createState() => _VendedTransactionsState();
}

class _VendedTransactionsState extends State<VendedTransactions> {
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
      content: Column(

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
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

            ],
          ),


        ],
      ),

    ).show();
  }

  _Paywithcash(context) {


  }
  late String AgentID;
  void initState() {
    super.initState();
    _loadCounter();
    // FirstName
    getEmail();
  }

  String FirstName = '';
  String LastName = '';

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {

      AgentID = preferences.getString('AgentID')?? '';
      FirstName = preferences.getString('FirstName')?? '';
      LastName = preferences.getString('LastName')?? '';

    });
  }

  void _loadCounter() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      AgentID = prefs.getString('AgentID')?? '';
    });
  }

  Future<List<Spacecraft5>> downloadJSON() async {




    final jsonEndpoint = Apis.AgentTransactionsGetByID;

    final response = await http.post(jsonEndpoint, body: {
      "AgentID": AgentID,
      "Action": '1',
      "parkingstatus": '1',

    });

    if (response.statusCode == 200) {
      List spacecrafts5 = json.decode(response.body);
      return spacecrafts5
          .map((spacecraft5) => new Spacecraft5.fromJson(spacecraft5))
          .toList();
    } else
      throw Exception('');
  }


  Future<List<Spacecraft9>> AgentTicketCount9() async {


    const jsonEndpoint = Apis.AgentBalance;

    final response = await http.post(jsonEndpoint, body: {
      "AgentID": AgentID,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts9 = json.decode(response.body);
      print(spacecrafts9);

      return spacecrafts9
          .map((spacecraft9) => new Spacecraft9.fromJson(spacecraft9))
          .toList();
    } else {
      throw Exception('');
    }  // Future<List<Spacecraft6>> AgentTicketCount6() async {
    //
    //
    //   const jsonEndpoint = Apis.AgentGetDetails;
    //
    //   final response = await http.post(jsonEndpoint, body: {
    //     "AgentID": AgentID,
    //     "Action": '1',
    //   });
    //
    //   if (response.statusCode == 200) {
    //     List spacecrafts6 = json.decode(response.body);
    //     print(spacecrafts6);
    //
    //     return spacecrafts6
    //         .map((spacecraft6) => new Spacecraft6.fromJson(spacecraft6))
    //         .toList();
    //   } else {
    //     throw Exception('');
    //   }
    // }

  }
  // Future<List<Spacecraft6>> AgentTicketCount6() async {
  //
  //
  //   const jsonEndpoint = Apis.AgentGetDetails;
  //
  //   final response = await http.post(jsonEndpoint, body: {
  //     "AgentID": AgentID,
  //     "Action": '1',
  //   });
  //
  //   if (response.statusCode == 200) {
  //     List spacecrafts6 = json.decode(response.body);
  //     print(spacecrafts6);
  //
  //     return spacecrafts6
  //         .map((spacecraft6) => new Spacecraft6.fromJson(spacecraft6))
  //         .toList();
  //   } else {
  //     throw Exception('');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      appBar:  AppBar(
        backgroundColor: Color(0xffffcc00),
        centerTitle: false,
        title: const Center(
            child: Text(
              "Parking History",
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


            Stack(
              children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Container(

                              padding: const EdgeInsets.only(
                                left: kDefaultPadding,
                                right: kDefaultPadding,

                              ),
                              height: 150,
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



                                  ),

                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 250,
                          //   height: 250,
                          //   color: Colors.amberAccent,
                          // ),
                          Positioned( //<-- SEE HERE

                            child:   SafeArea(

                              child:  FutureBuilder<List<Spacecraft9>>(
                                future: AgentTicketCount9(),
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                builder: (context, snapshot) {


                                  if (snapshot.hasData) {
                                    List<Spacecraft9>? spacecrafts9 = snapshot.data;
                                    return CustomListView9(spacecrafts9!);
                                  } else if (snapshot.hasError) {
                                    child: Center(child: Text('No Parking Transactions Yet'));
                                    //return Text('0');return Text('No Report Yet');
                                  }
                                  //return  a circular progress indicator.
                                  return  CircularProgressIndicator();


                                },

                              ),
                            ),
                          ),
                        ],
                      ),


                    ],



                  ),



              ],
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
                  SafeArea(

                    child: FutureBuilder<List<Spacecraft5>>(
                      future: downloadJSON(),
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      builder: (context, snapshot) {


                        if (snapshot.hasData) {
                          List<Spacecraft5>? spacecrafts = snapshot.data;
                          return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: CustomListView5(spacecrafts!));
                        } else if (snapshot.hasError) {
                          //return Text('${snapshot.error}');
                          return Container(

                              child: const Center(child: Text('No Transaction')));
                        }
                        //return  a circular progress indicator.
                        return  CircularProgressIndicator();


                      },

                    ),
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
