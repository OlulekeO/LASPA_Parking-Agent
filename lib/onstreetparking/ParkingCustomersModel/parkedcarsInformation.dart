import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences localStorage;

class Spacecraft {
  final String NumberOfTicket,GrossTotal,AvailableSpace,currentparking;

  Spacecraft({
    required this.NumberOfTicket,
    required this.GrossTotal,
    required this.AvailableSpace,
    required this.currentparking,



  });

  factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft(
      NumberOfTicket: jsonData['NumberOfTicket'],
      GrossTotal: jsonData['GrossTotal'],
      AvailableSpace: jsonData['AvailableSpace'],
      currentparking: jsonData['currentparking'],


    );


  }

}

late final List<Spacecraft> spacecrafts;
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
    itemCount: spacecrafts.length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem(spacecrafts[currentIndex], context);
    },
  );
}


class CustomListView extends StatefulWidget {
  final List<Spacecraft> spacecrafts;

  CustomListView(this.spacecrafts);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

late String AgentID;

class _CustomListViewState extends State<CustomListView> {




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
      itemCount: widget.spacecrafts.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(widget.spacecrafts[currentIndex], context);
      },
    );
  }
}

Widget createViewItem(Spacecraft spacecraft, BuildContext context) {
  return ListTile(
      title: Container(
        child:    Column(
          children: [

            Row(
              children: <Widget>[
                Expanded(
                  child: Text(spacecraft.AvailableSpace,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(spacecraft.NumberOfTicket,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(spacecraft.currentparking,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center),
                ),
              ],
            ),

          ],
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


