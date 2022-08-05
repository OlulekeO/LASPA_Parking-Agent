import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';



import 'ParkingCustomersModel/CurrentParkingCustomers.dart';
import 'constants.dart';
class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
    child: Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      appBar:  AppBar(
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: 11,
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        "assets/LASPAo.png",
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Good Afternoon,  \n Leke',

                          style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                        ),
                      ),

                      Spacer(),
                      Image.asset("assets/Transaction.png"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                            "assets/Icon ionic-ios-notifications-outline.png"),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    child: Column(
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
                        Row(
                          children: const <Widget>[
                            Expanded(
                              child: Text('120 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Expanded(
                              child: Text('90 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Expanded(
                              child: Text('76 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //tab view will be here ooo
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Color(0xffffffff),
                bottom: TabBar(
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
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  // createViewItem(),

                  Container(
                    color: Color(0xffD8D8D8),
                    child: Center(
                      child: Column(
                        children: [
                          // Text(
                          //   'Bike',
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                color: Color(0xffD8D8D8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffffffff),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                             // color: Color(0xffD8D8D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "IKJ-354TY",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:    Text(
                                      "2:10pm",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "2hrs left",
                                    ),
                                  ),
                                  Image.asset("assets/Transaction.png"),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                color: Color(0xffD8D8D8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffffffff),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              // color: Color(0xffD8D8D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "IKJ-354TY",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:    Text(
                                      "2:10pm",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "2hrs left",
                                    ),
                                  ),
                                  Image.asset("assets/Transaction.png"),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // second tab bar viiew widget
                  Container(
                    color: Color(0xffD8D8D8),
                    child: Center(
                      child: Column(
                        children: [
                          // Text(
                          //   'Bike',
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                color: Color(0xffD8D8D8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffffffff),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              // color: Color(0xffD8D8D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "IKJ-354TY",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:    Text(
                                      "2:10pm",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "2hrs left",
                                    ),
                                  ),
                                  Image.asset("assets/Transaction.png"),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                color: Color(0xffD8D8D8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffffffff),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              // color: Color(0xffD8D8D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "IKJ-354TY",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:    Text(
                                      "2:10pm",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "2hrs left",
                                    ),
                                  ),
                                  Image.asset("assets/Transaction.png"),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xffD8D8D8),
                    child: Center(
                      child: Column(
                        children: [
                          // Text(
                          //   'Bike',
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                color: Color(0xffD8D8D8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffffffff),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              // color: Color(0xffD8D8D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "IKJ-354TY",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:    Text(
                                      "2:10pm",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "Expired",
                                    ),
                                  ),
                                  Image.asset("assets/Transaction.png"),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                color: Color(0xffD8D8D8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffffffff),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              // color: Color(0xffD8D8D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "IKJ-354TY",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:    Text(
                                      "2:10pm",
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      "Expired",
                                    ),
                                  ),
                                  Image.asset("assets/Transaction.png"),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),






          ],
        ),
      ),

          ),
    );
  }
}
