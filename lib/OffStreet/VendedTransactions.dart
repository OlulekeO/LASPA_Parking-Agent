import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'CurrentParkingCustomers.dart';
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
                ' *737*2*1000?? ',
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
                          'Thursday,Dec 5,2021',
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

                            left: 30,
                          ),
                          child: Column(

                            children: [

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Sam Cromer",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("EKY-123-AAA",
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

                              Text("1,000",
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
          MaterialButton(

            minWidth: double.infinity,
            height: 40,
            color: Color(0xffffcc00),
            onPressed: () {
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

  _Paywithcash(context) {
    Alert(
      context: context,
      title: "Pay with Cash",
      buttons: [],
      content: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Duration',
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
              labelText: 'Amount',
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

    ).show();
  }
  late String id;
  void initState() {
    super.initState();
    _loadCounter();
  }
  void _loadCounter() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('AgentCode')?? '';
    });
  }

  Future<List<Spacecraft>> downloadJSON() async {




    final jsonEndpoint = "https://app.prananet.io/LaspaApp/Api/AgentTransactionsGetByID";

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": id,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      appBar: new AppBar(
        backgroundColor: Color(0xffffcc00),
        centerTitle: false,
        title: Center(
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,

              child: Stack(

                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,

                    ),
                    height: 150,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              "assets/LASPAo.png",
                              height: 40,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Hello,  \n Agent',

                                style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VendedTransactions()));


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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Container(
                      margin: const EdgeInsets.only(top: 80.0),
                      decoration: BoxDecoration(
                        color: Color(0xff2E2F39),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 80,
                      width: double.infinity,
                      // color: Color(0xffffffff),
                      child: Center(
                        child: Column(
                          children: const [
                            Center(child: Text(
                              "Vended Amount",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xffffffff),
                              ),
                            ),),
                            SizedBox(
                              height: 15,
                            ),
                            Center(child: Text(
                              "N 0 ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xffffffff),
                              ),
                            ),),
                          ],
                        ),
                      ),


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
                      SafeArea(

                        child: new FutureBuilder<List<Spacecraft>>(
                          future: downloadJSON(),
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          builder: (context, snapshot) {


                            if (snapshot.hasData) {
                              List<Spacecraft>? spacecrafts = snapshot.data;
                              return SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: new CustomListView(spacecrafts!));
                            } else if (snapshot.hasError) {
                              //return Text('${snapshot.error}');
                              return Container(

                                  child: Text('No Transaction'));
                            }
                            //return  a circular progress indicator.
                            return new CircularProgressIndicator();


                          },

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
    );
  }
}
