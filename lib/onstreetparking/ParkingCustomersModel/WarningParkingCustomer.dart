import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import '../../Apis/api_base.dart';
import '../../Profile/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences localStorage;

class Spacecraft1 {
  final String ParkingID,AgentID,ExpiringTime,ParkingTime;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  Spacecraft1({
    required this.ParkingID,
    required this.AgentID,
    required this.Location,
    required this.ParkingTime,
    required this.ExpiringTime,
    required this.PlateNumber,
    required this.ParkingHour,
    required this.Parkingstatus,
    required this.channel,
    required this.TrnxRef,
    required this.DateAdded,
    required this.DateCreated,
    required this.Amount,
  });

  factory Spacecraft1.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft1(
      ParkingID: jsonData['ParkingID'],
      AgentID: jsonData['AgentID'],
      Location: jsonData['Location'],
      PlateNumber: jsonData['PlateNumber'],
      ParkingHour: jsonData['ParkingHour'],
      ExpiringTime: jsonData['ExpiringTime'],
      ParkingTime: jsonData['ParkingTime'],
      // reportTitle: jsonData['ReportTitle'],
      Parkingstatus: jsonData['Parkingstatus'],
      channel:jsonData['channel'],
      TrnxRef:jsonData['TrnxRef'],
      DateAdded:jsonData['DateAdded'],
      DateCreated:jsonData['DateCreated'],
      Amount:jsonData['Amount'],
    );
  }
}

late final List<Spacecraft1> spacecrafts1;
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
    itemCount: spacecrafts1.length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem1(spacecrafts1[currentIndex], context);
    },
  );
}


class CustomListView1 extends StatefulWidget {
  final List<Spacecraft1> spacecrafts1;

  CustomListView1(this.spacecrafts1);

  @override
  State<CustomListView1> createState() => _CustomListView1State();
}

class _CustomListView1State extends State<CustomListView1> {
  // Future getEmail()async{
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     SubMarshalID = preferences.getString('AgentCode');
  //   });
  // }

  late String AgentID;



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
      AgentID = preferences.getString('AgentID')?? '';;
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
      itemCount: widget.spacecrafts1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem1(widget.spacecrafts1[currentIndex], context);
      },
    );
  }
}


Future<List<User>> ParkingInfo() async {
  String url = Apis.AgentTransactionsGetByID;
  final response = await http.post(url, body: {
    "AgentID": AgentID,
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


Widget createViewItem1(Spacecraft1 spacecraft1, BuildContext context) {
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //
                      //
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child:    Text(
                      //        'Plate Number',
                      //         style: TextStyle(
                      //
                      //           fontSize: size.width * 0.03,
                      //         ),
                      //
                      //
                      //       ),
                      //
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(2.0),
                      //       child:    Text(
                      //       'Expiring Time',
                      //         style: TextStyle(
                      //
                      //           fontSize: size.width * 0.03,
                      //         ),
                      //       ),
                      //
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child:    Text(
                      //         "Minutes left",
                      //         style: TextStyle(
                      //
                      //           fontSize: size.width * 0.03,
                      //         ),
                      //       ),
                      //     ),
                      //     // Image.asset("assets/Transaction.png"),
                      //
                      //   ],
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:    Text(
                                spacecraft1.PlateNumber,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03,
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child:    Text(
                                spacecraft1.ParkingTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03,
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:    Text(
                                spacecraft1.ExpiringTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03,
                                ),
                              ),
                            ),
                            // Image.asset("assets/Transaction.png"),

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


