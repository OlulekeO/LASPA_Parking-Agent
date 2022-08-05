import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences localStorage;

// late String SubMarshalID;
// late String MashalID;
class Spacecraft1 {
  final String ParkingID,SubMarshalID;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  Spacecraft1({
    required this.ParkingID,
    required this.SubMarshalID,
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

  factory Spacecraft1.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft1(
      ParkingID: jsonData['ParkingID'],
      SubMarshalID: jsonData['SubMarshalID'],
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
  }
}

late final List<Spacecraft1> spacecrafts1;
class User {
  final String ParkingID,SubMarshalID;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  User({
    required this.ParkingID,
    required this.SubMarshalID,
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

  late String SubMarshalID;



  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      SubMarshalID = localStorage.getString('AgentCode')?? '';
      //  userEmail = localStorage.getString('Email');
    });
  }
  @override

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      SubMarshalID = preferences.getString('AgentCode')?? '';
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
  String url = "https://app.prananet.io/LaspaApp/Api/AgentTransactionsGetByID";
  final response = await http.post(url, body: {
    "MashalID": '1',
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
      SubMarshalID: jsonData['SubMarshalID'],
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
  return new ListTile(
      title: new   Container(
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
                          spacecraft1.PlateNumber,
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:    Text(
                          spacecraft1.ParkingHour,
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


