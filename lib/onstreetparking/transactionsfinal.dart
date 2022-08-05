import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../Profile/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../Apis/api_base.dart';
import 'AgentTicketInformation.dart';
import 'ParkingCustomersModel/CurrentParkingCustomers.dart';
import 'ParkingCustomersModel/ExpiredParkingCustomer.dart';
import 'ParkingCustomersModel/WarningParkingCustomer.dart';
import 'constants.dart';

String _email='';
//
// String localStorage;

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late String id;

  void initState() {
    super.initState();
    _loadCounter();
  }

  getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _email = preferences.getString('AgentCode')?? '';
    });
  }
  gettime()async{

    var format = DateFormat("HH:mm");
    var one = format.parse("10:00");
    var two = format.parse("12:00");
    print("${two.difference(one)}");
    // setState(() {
    //   gettime();
    // });

  }


  void _loadCounter() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('AgentCode')?? '';
    });
  }
  Future<List<Spacecraft1>> downloadJSON1() async {


    final jsonEndpoint = Apis.AgentTransactionsGetByID;

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": id,
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
      "MashalID": id,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts = json.decode(response.body);
      return spacecrafts
          .map((spacecraft) => new Spacecraft.fromJson(spacecraft))
          .toList();
    } else
      throw Exception('');
  }
  Future<List<Spacecraft2>> downloadJSON2() async {


    const jsonEndpoint = Apis.AgentTransactionsGetByID;

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": id,
    });

    if (response.statusCode == 200) {
      List spacecrafts2 = json.decode(response.body);
      return spacecrafts2
          .map((spacecraft2) =>  Spacecraft2.fromJson(spacecraft2))
          .toList();
    } else {
      throw Exception('');
    }
  }

  Future<List<Spacecraft>> AgentTicketCount() async {


    const jsonEndpoint = Apis.AgentTicketGet;

    final response = await http.post(jsonEndpoint, body: {
      "MashalID": id,
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
      "MashalID": id,
      "Action": '1',
    });

    if (response.statusCode == 200) {
      List spacecrafts6 = json.decode(response.body);
      print(spacecrafts6);

      gettime();

      return spacecrafts6
          .map((spacecraft6) => new Spacecraft6.fromJson(spacecraft6))
          .toList();
    } else
      throw Exception('We were not able to successfully download the json data.');
  }

  @override



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
                'Transactions',
                style: TextStyle(
                  color: Color(0xff000000),
                ),
              )),



          elevation: 0,

        ),

        body: SingleChildScrollView(
          child: Column(
            children: [

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
        ),

      ),
    );
  }
}
