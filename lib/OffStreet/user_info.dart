import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import '../../onstreetparking/VendedTransactions.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences localStorage;
late String SubMarshalID;
late String SubMarshalFirstName;
late String SubMarshalLastName;
late String phonenumber;
late String SubMarshalEmail;
late String ConcessionaireID;
late String SubMarshalLocation;
late String MSubMarshalCode;
// late String SubMarshalID;
// late String MashalID;
class Spacecraft6{
  final String SubMarshalID;
  final String SubMarshalFirstName;
  final String SubMarshalLastName;
  final String phonenumber;
  final String SubMarshalEmail;
  final String ConcessionaireID;
  final String SubMarshalLocation;
  final String MSubMarshalCode;

  Spacecraft6({
    required this.SubMarshalID,
    required this.SubMarshalFirstName,
    required this.SubMarshalLastName,
    required this.phonenumber,
    required this.SubMarshalEmail,
    required this.ConcessionaireID,
    required this.SubMarshalLocation,
    required this.MSubMarshalCode,

  });

  factory Spacecraft6.fromJson(Map<String, dynamic> singleUser) {
    return Spacecraft6(
        SubMarshalID: singleUser["SubMarshalID"],
        SubMarshalFirstName: singleUser["SubMarshalFirstName"],
        SubMarshalLastName: singleUser["SubMarshalLastName"],
        phonenumber: singleUser["phonenumber"],
        SubMarshalEmail: singleUser["SubMarshalEmail"],
        ConcessionaireID: singleUser["ConcessionaireID"],
        SubMarshalLocation: singleUser["SubMarshalLocation"],
        MSubMarshalCode: singleUser["MSubMarshalCode"]);



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
      itemCount: widget.spacecrafts6.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem6(widget.spacecrafts6[currentIndex], context);
      },
    );
  }
}

Widget createViewItem6(Spacecraft6 spacecraft6, BuildContext context) {
  return new ListTile(
      title: new   Column(
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
                  'Hello, Enforcer',

                  style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                ),
              ),
              Spacer(),
              // GestureDetector(
              //     onTap: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context) => VendedTransactions()));
              //
              //
              //     },
              //     child: Image.asset("assets/Transaction.png")),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Image.asset(
              //       "assets/Icon ionic-ios-notifications-outline.png"),
              // ),
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


