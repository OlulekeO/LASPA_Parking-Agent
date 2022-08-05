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
class Spacecraft9 {
  final String WalletAmount;

  Spacecraft9 ({
    required this.WalletAmount,


  });

  factory Spacecraft9 .fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft9 (
      WalletAmount: jsonData['WalletAmount'],

    );


  }

}

late final List<Spacecraft9 > spacecrafts9 ;
// class User {
//   final String ParkingID,SubMarshalID;
//   final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;
//
//   User({
//     required this.ParkingID,
//     required this.SubMarshalID,
//     required this.Location,
//     required this.PlateNumber,
//     required this.ParkingHour,
//     required this.Parkingstatus,
//     required this.channel,
//     required this.TrnxRef,
//     required this.DateAdded,
//     required this.DateCreated,
//     required this.Amount,
//   });
// }

Widget build(context) {
  return ListView.builder(
    itemCount: spacecrafts9 .length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem9(spacecrafts9 [currentIndex], context);
    },
  );
}


class CustomListView9  extends StatefulWidget {
  final List<Spacecraft9 > spacecrafts9 ;

  CustomListView9 (this.spacecrafts9 );

  @override
  State<CustomListView9 > createState() => _CustomListView9State();
}

late String AgentID;

class _CustomListView9State extends State<CustomListView9> {
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
      itemCount: widget.spacecrafts9.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem9(widget.spacecrafts9[currentIndex], context);
      },
    );
  }
}

Widget createViewItem9(Spacecraft9 spacecraft9, BuildContext context) {
  return ListTile(
      title: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: double.infinity,
              ),
              margin: const EdgeInsets.only(top: 90.0),
              decoration: const BoxDecoration(
                color: Color(0xff2E2F39),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

              width: double.infinity,
              // color: Color(0xffffffff),
              child: Center(
                child: Column(
                  children: [
                    const Center(child: Text(
                      "Vended Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffffffff),
                      ),
                    ),),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(child: Text(
                      '₦ ' + spacecraft9.WalletAmount,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffffffff),
                      ),
                    ),),
                  ],
                ),
              ),


            ),

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


