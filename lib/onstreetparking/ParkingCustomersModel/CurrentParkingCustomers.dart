import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences localStorage;

late String AgentID;

class Spacecraft5 {
  final String ParkingID,AgentID,ExpiringTime,ParkingTime;
  final String Location,PlateNumber,ParkingHour,Parkingstatus,channel,TrnxRef,DateAdded,DateCreated,Amount;

  Spacecraft5({
    required this.ParkingID,
    required this.AgentID,
    required this.Location,
    required this.ParkingTime,
    required this.PlateNumber,
    required this.ParkingHour,
    required this.ExpiringTime,

    required this.Parkingstatus,
    required this.channel,
    required this.TrnxRef,
    required this.DateAdded,
    required this.DateCreated,
    required this.Amount,
  });

  factory Spacecraft5.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft5(
      ParkingID: jsonData['ParkingID'],
      AgentID: jsonData['AgentID'],
      Location: jsonData['Location'],
      PlateNumber: jsonData['PlateNumber'],
      ParkingHour: jsonData['ParkingHour'],
      ExpiringTime: jsonData['ExpiringTime'],
      ParkingTime: jsonData['ParkingTime'],
      Parkingstatus: jsonData['Parkingstatus'],
      channel:jsonData['channel'],
      TrnxRef:jsonData['TrnxRef'],
      DateAdded:jsonData['DateAdded'],
      DateCreated:jsonData['DateCreated'],
      Amount:jsonData['Amount'],
    );
  }
}

late final List<Spacecraft5> spacecrafts5;
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
    itemCount: spacecrafts5.length,
    itemBuilder: (context, int currentIndex) {
      return createViewItem2(spacecrafts5[currentIndex], context);
    },
  );
}


class CustomListView5 extends StatefulWidget {
  final List<Spacecraft5> spacecrafts5;

  CustomListView5(this.spacecrafts5);

  @override
  State<CustomListView5> createState() => _CustomListView5State();
}

class _CustomListView5State extends State<CustomListView5> {
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
      itemCount: widget.spacecrafts5.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem2(widget.spacecrafts5[currentIndex], context);
      },
    );
  }
}



Widget createViewItem2(Spacecraft5 spacecraft5, BuildContext context) {
  final size = MediaQuery.of(context).size;
  double height, width;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return  ListTile(
      title:    Container(
        color: const Color(0xffD8D8D8),
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

                  decoration: const BoxDecoration(
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
                      //         'Plate Number',
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
                      //         'Start Time',
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
                      //         "Expiring Time",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              spacecraft5.PlateNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.03,
                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child:    Text(
                              spacecraft5.ParkingTime,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.03,
                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:    Text(
                              spacecraft5.ExpiringTime,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.03,
                              ),
                            ),
                          ),
                          // Image.asset("assets/Transaction.png"),

                        ],
                      ),
                    ],

                  ),
                ),
              ),







            ],
          ),
        ),
      ),
      onTap: () {

        var route = MaterialPageRoute(
          builder: (BuildContext context) =>
          new reportDetails(value: spacecraft5),
        );
        Navigator.of(context).push(route);

      });

}

class reportDetails extends StatefulWidget {
  final Spacecraft5 value;
  // const reportDetails({Key? key,this.value}) : super(key: key);
  reportDetails({Key? key, required this.value}) : super(key: key);

  @override
  _reportDetailsState createState() => _reportDetailsState();
}

class _reportDetailsState extends State<reportDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00),
        centerTitle: false,
        title: const Center(
            child: Text(
              "Parking Information",
              style: TextStyle(
                color: Color(0xff000000),
              ),
            )),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Container(

          color: Color(0xffffffff),
          child: Column(
            children: <Widget>[


              SizedBox(
                height: 10,
              ),
            Center(child: Text('Customer Parking Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

            )),

              SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Plate Number',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.PlateNumber}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),


              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Hours',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.ParkingHour}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Start Time',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.ParkingTime}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),

              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Expiring Time',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.ExpiringTime}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),

              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Amount Paid',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.Amount}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),

              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Payment Method',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.channel}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Location',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          ' ${widget.value.Location}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),



              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Phone Number',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          '*********',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: MaterialButton(
              //     minWidth: double.infinity,
              //     height: 60,
              //     onPressed: () async {
              //
              //     },
              //     color: Color(0xffffcc00),
              //
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(50),
              //
              //     ),
              //     child: Text(
              //       "Notify", style: TextStyle(
              //       fontWeight: FontWeight.w600,
              //       fontSize: 18,
              //       color: Colors.black,
              //
              //     ),
              //     ),
              //
              //   ),
              // ),



            ],   ),
        ),
      ),
    );
  }
}

//Future is n object representing a delayed computation.


