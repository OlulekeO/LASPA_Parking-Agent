import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Apis/api_base.dart';
late SharedPreferences localStorage;


late String AgentID;

class Spacecraft2 {
  final String ParkingID,AgentID,ExpiringTime,ParkingTime,Notify;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  Spacecraft2({
    required this.ParkingID,
    required this.AgentID,
    required this.Location,
    required this.PlateNumber,
    required this.ParkingTime,
    required this.Notify,
    required this.ExpiringTime,
    required this.ParkingHour,
    required this.Parkingstatus,
    required this.channel,
    required this.TrnxRef,
    required this.DateAdded,
    required this.DateCreated,
    required this.Amount,
  });

  factory Spacecraft2.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft2(
      ParkingID: jsonData['ParkingID'],
      AgentID: jsonData['AgentID'],
      Location: jsonData['Location'],
      PlateNumber: jsonData['PlateNumber'],
      ExpiringTime: jsonData['ExpiringTime'],
      ParkingTime: jsonData['ParkingTime'],
      ParkingHour: jsonData['ParkingHour'],
      // reportTitle: jsonData['ReportTitle'],
      Parkingstatus: jsonData['Parkingstatus'],
      channel:jsonData['channel'],
      TrnxRef:jsonData['TrnxRef'],
      DateAdded:jsonData['DateAdded'],
      DateCreated:jsonData['DateCreated'],
      Amount:jsonData['Amount'],
      Notify:jsonData['Notify'],

    );
  }
}

late final List<Spacecraft2> spacecrafts2;
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
    itemCount: spacecrafts2.length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem2(spacecrafts2[currentIndex], context);
    },
  );
}


class CustomListView2 extends StatefulWidget {
  final List<Spacecraft2> spacecrafts2;

  CustomListView2(this.spacecrafts2);

  @override
  State<CustomListView2> createState() => _CustomListView2State();
}

class _CustomListView2State extends State<CustomListView2> {
  // Future getEmail()async{
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     SubMarshalID = preferences.getString('AgentCode');
  //   });
  // }



  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      AgentID = localStorage.getString('AgentID')?? '';
      //  userEmail = localStorage.getString('Email');
    });
  }
  @override

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
    //getRequest();
  }
  Widget build(context) {
    return ListView.builder(
      itemCount: widget.spacecrafts2.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem2(widget.spacecrafts2[currentIndex], context);
      },
    );
  }
}


Future<List<User>> ParkingInfo() async {
  String url = Apis.AgentTransactionsGetByID;
  final response = await http.post(url, body: {
    "MashalID": AgentID,
    "Action":'1',
  });

  var responseData = json.decode(response.body);
  print(responseData);
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


Widget createViewItem2(Spacecraft2 spacecraft2, BuildContext context) {
  final size = MediaQuery.of(context).size;
  double height, width;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return  ListTile(
      title:    Container(
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
                  // height: height * 0.08,

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
                  child: Column(

                    children: [

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:    Text(
                                spacecraft2.PlateNumber,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03,
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child:    Text(
                                spacecraft2.ParkingTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03,
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:    Text(
                                spacecraft2.ExpiringTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03,
                                ),
                              ),
                            ),
                            if (spacecraft2.Notify == '1') ...[

                              Image.asset(
                                  "assets/Icon ionic-ios-notifications-outline.png",
                                color: Color(0xffFF0000),
                              ),


                            ]

                            else ...[
                              Image.asset(
                                "assets/Icon ionic-ios-notifications-outline.png"
                              ),

                            ],

                          ],
                        ),
                      ),
                    ],

                  ),
                ),
              ),






              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: 60,
              //
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              //       color: Color(0xffD8D8D8),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Color(0xffffffff),
              //           offset: Offset(0.0, 1.0), //(x,y)
              //           blurRadius: 5.0,
              //         ),
              //       ],
              //     ),
              //     // color: Color(0xffD8D8D8),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //
              //
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child:    Text(
              //             spacecraft.PlateNumber,
              //           ),
              //
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(2.0),
              //           child:    Text(
              //             spacecraft.ParkingHour,
              //           ),
              //
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child:    Text(
              //             "2hrs left",
              //           ),
              //         ),
              //         Image.asset("assets/Transaction.png"),
              //
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              //
            ],
          ),
        ),
      ),
      onTap: () {

        // var route = new MaterialPageRoute(
        //   builder: (BuildContext context) =>
        //   new reportDetails(value: spacecraft),
        // );
        // Navigator.of(context).push(route);

      });

}
//Future is n object representing a delayed computation.


