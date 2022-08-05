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
class Spacecraft {
  final String NumberOfTicket,GrossTotal;

  Spacecraft({
    required this.NumberOfTicket,
    required this.GrossTotal,

  });

  factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft(
      NumberOfTicket: jsonData['NumberOfTicket'],
      GrossTotal: jsonData['GrossTotal'],

    );


  }

}

late final List<Spacecraft> spacecrafts;
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

late String SubMarshalID;

class _CustomListViewState extends State<CustomListView> {
  // Future getEmail()async{
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     SubMarshalID = preferences.getString('AgentCode');
  //   });
  // }





  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      SubMarshalID = localStorage.getString('AgentCode')?? '';
      //  userEmail = localStorage.getString('Email');
    });
  }
  @override

  Future getEmail()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      SubMarshalID = localStorage.getString('AgentCode')?? '';
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
  return new ListTile(
      title: Container(
        child: new   Column(
          children: [

            Row(
              children: <Widget>[
                Expanded(
                  child: Text('2 ',
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
                  child: Text(spacecraft.NumberOfTicket,
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


