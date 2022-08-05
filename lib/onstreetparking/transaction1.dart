import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';



import '../Apis/api_base.dart';
import 'ParkingCustomersModel/CurrentParkingCustomers.dart';
import 'constants.dart';
class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  Future<List<User>> ParkingInfo() async {
    String url = Apis.AgentTransactionsGetByID;
    var id;
    final response = await http.post(url, body: {
      "MashalID": id,
    });

    var responseData = json.decode(response.body);
    // print(responseData);
    // Map message = jsonDecode(responseData);
    // String name = message['firstname'];
    // print (name);

    // Creating a list to store input data;
    List<User> users = [];
    for (var jsonData in responseData) {
      User user = User(
        ParkingID: jsonData['ParkingID'],
        AgentID: jsonData['AgentID'],
        Location: jsonData['Location'],
        PlateNumber: jsonData['PlateNumber'],
        ParkingHour: jsonData['ParkingHour'],
        // reportTitle: jsonData['ReportTitle'],
        Parkingstatus: jsonData['Parkingstatus'],
        channel:jsonData['channel'],
        TrnxRef:jsonData['TrnxRef'],
        DateAdded:jsonData['DateAdded'],
        DateCreated:jsonData['DateCreated'],
        Amount:jsonData['Amount'],
      );
      //Adding user to the list.
      users.add(user);

      // localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('SubMarshalID',user.SubMarshalID);
      //


    }
    return users;
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
                "Parking Transactinos",
                style: TextStyle(
                  color: Color(0xff000000),
                ),
              )),

          elevation: 0,
        ),
        body: Container(
          child: FutureBuilder<List<User>>(
            future: ParkingInfo(),

            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }else{

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, index) {
                      User user = snapshot.data[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            child: Container(
                              padding: EdgeInsets.only(
                                left: kDefaultPadding,
                                right: kDefaultPadding,
                                bottom: 10,
                              ),
                              height: 160,
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
                                          'Good Afternoon,  \n' + '${user.channel}' ,

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
                          ),
                          SizedBox(
                            height: 60,
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
                          //tab view will be here ooo
                          SizedBox(
                            height: 2,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(28.0),
                          //   child: TextField(
                          //     style: TextStyle(
                          //
                          //       height: 0.0,
                          //
                          //     ),
                          //     decoration: InputDecoration(
                          //
                          //       enabledBorder: new OutlineInputBorder(
                          //         borderRadius: new BorderRadius.circular(10.0),
                          //         borderSide:  BorderSide(color: Colors.yellow ),
                          //
                          //       ),
                          //       focusedBorder: new OutlineInputBorder(
                          //         borderRadius: new BorderRadius.circular(25.0),
                          //         borderSide:  BorderSide(color: Colors.yellow ),
                          //
                          //       ),
                          //       filled: true,
                          //       hintStyle: TextStyle(color: Colors.white),
                          //       // hintText: "Type in your text",
                          //       fillColor: Color(0xffffffff),
                          //       suffixIcon: Icon(Icons.search),
                          //
                          //     ),
                          //   ),
                          // ),
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
                                                    "${user.PlateNumber}",
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

                          // create widgets for each tab bar here

                        ],
                      );
                    },
                  ),
                );


              }

            },

          ),
        ),

      ),
    );
  }
}
