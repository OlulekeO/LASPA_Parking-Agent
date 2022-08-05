import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;

import 'package:shared_preferences/shared_preferences.dart';

import '../OffStreet/VendedTransactions.dart';
late SharedPreferences localStorage;
late String AgentID;
late String FirstName;
late String LastName;
late String ParkingAreaID;
late String Email;
late String ConcessionaireID;
late String Location;
late String Code;
late String Name;

// late String SubMarshalID;
// late String MashalID;
class Spacecraft6{
  final String AgentID;
  final String FirstName;
  final String LastName;
  final String ParkingAreaID;
  final String Email;
  final String ConcessionaireID;
  final String Location;
  final String Code;
  final String Name;


  Spacecraft6({
    required this.AgentID,
    required this.FirstName,
    required this.LastName,
    required this.ParkingAreaID,
    required this.Email,
    required this.ConcessionaireID,
    required this.Location,
    required this.Code,
    required this.Name,

  });

  factory Spacecraft6.fromJson(Map<String, dynamic> singleUser) {
    return Spacecraft6(
        AgentID: singleUser["AgentID"],
        FirstName: singleUser["FirstName"],
        LastName: singleUser["LastName"],
        ParkingAreaID: singleUser["ParkingAreaID"],
        Email: singleUser["Email"],
        ConcessionaireID: singleUser["ConcessionaireID"],
        Location: singleUser["Location"],
        Name: singleUser["Name"],
        Code: singleUser["Code"]);



  }

}

late final List<Spacecraft6> spacecrafts6;
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
    itemCount: spacecrafts6.length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem6(spacecrafts6[currentIndex], context);
    },
  );
}


class CustomListView6 extends StatefulWidget {
  final List<Spacecraft6> spacecrafts6;

  CustomListView6(this.spacecrafts6);

  @override
  State<CustomListView6> createState() => _CustomListView6State();
}

//late String SubMarshalID;

class _CustomListView6State extends State<CustomListView6> {
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
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      AgentID = localStorage.getString('AgentID')?? '';
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
      shrinkWrap: true,
      itemCount: widget.spacecrafts6.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem6(widget.spacecrafts6[currentIndex], context);
      },
    );
  }
}

Widget createViewItem6(Spacecraft6 spacecraft6, BuildContext context) {
  return ListTile(
      title: Column(
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
                  'Hello, ' + spacecraft6.FirstName,

                  style: const TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                ),
              ),
              Spacer(),
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
      onTap: () {

        // var route = new MaterialPageRoute(
        //   builder: (BuildContext context) =>
        //   new reportDetails(value: spacecraft),
        // );
        // Navigator.of(context).push(route);

      });

}
//Future is n object representing a delayed computation.


