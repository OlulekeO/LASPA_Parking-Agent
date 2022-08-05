import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Apis/api_base.dart';
import 'OffStreet/Transactions.dart';
import 'Profile/user_info.dart';
import 'authentication/login.dart';
import 'onstreetparking/HomePage/Home.dart';
import 'authentication/signup.dart';
import 'onstreetparking/OnStreetLanding.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';



void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Landing(),
  ));
}

late SharedPreferences localStorage;

//Creating a class user to store the data;
class User {
  final String AgentID;
  final String FirstName;
  final String LastName;
  final String ParkingAreaID;
  final String Email;
  final String ConcessionaireID;
  final String Location;
  final String Code;
  final String Name;
  User({
    required this.AgentID,
    required this.FirstName,
    required this.LastName,
    required this.ParkingAreaID,
    required this.Email,
    required this.ConcessionaireID,
    required this.Location,
    required this.Code,
    required this.Name

  });
}


class Landing extends StatefulWidget {





  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {

 // UserInfo info = UserInfo();

  late String AgentID;
  late String FirstName;
  late String LastName;
  late String ParkingAreaID;
  late String Email;
  late String ConcessionaireID;
  late String Location;
  late String Code;
  late String Name;


  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   initial();
  // }
  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      AgentID = localStorage.getString('AgentID')?? '';
      //  userEmail = localStorage.getString('Email');
    });
  }

  Future<List<User>> getRequest() async {
    String url = Apis.AgentGetDetails;
    final response = await http.post(url, body: {
      "AgentID": AgentID,
    });

    var responseData = json.decode(response.body);

    // print(responseData);
    // Map message = jsonDecode(responseData);
    // String name = message['firstname'];
    // print (name);

    // Creating a list to store input data;
    List<User> users = [];
    for (var singleUser in responseData) {
      User user = User(
          AgentID: singleUser["AgentID"],
          FirstName: singleUser["FirstName"],
          LastName: singleUser["LastName"],
          ParkingAreaID: singleUser["ParkingAreaID"],
          Email: singleUser["Email"],
          ConcessionaireID: singleUser["ConcessionaireID"],
          Location: singleUser["LocationID"],
          Name: singleUser["Name"],
          Code: singleUser["Code"]);

      //Adding user to the list.
      users.add(user);

      localStorage = await SharedPreferences.getInstance();
      localStorage.setString('AgentID',user.AgentID);

      localStorage = await SharedPreferences.getInstance();
      localStorage.setString('ParkingAreaID',user.ParkingAreaID);


      // print(user.AgentID);


     var ParkingAreaID = localStorage.getString('ParkingAreaID');
      // print(ParkingAreaID);
      // print('Goooooooooood');

    }
    return users;
  }



  //String SubMarshalID = "";

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: FutureBuilder(
          // we will give media query height
          // double.infinity make it big as my parent allows
          // while MediaQuery make it big as per the screen

          future: getRequest(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {


            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) {
                  User user = snapshot.data[index];
                  return Column(
                    // even space distribution
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        height:300,
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height / 3,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/Parking lot security.png"),

                            )
                        ),
                      ),

                      Column(
                        children: <Widget>[
                          // the login button
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: const Color(0xffffcc00),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));

                            },
                            // defining the shape
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black
                                ),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: const Text(
                              "On-Street",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),
                            ),
                          ),
                          // creating the signup button
                          SizedBox(height:20),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Color(0xffD8D8D8),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

                            },
                            // defining the shape
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black
                                ),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text(
                              "Off-Street",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: Text(
                          //     '${user.SubMarshalFirstName}',
                          //     style: TextStyle(
                          //       fontSize: 20.0,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          // MaterialButton(
                          //   minWidth: double.infinity,
                          //   height: 60,
                          //   onPressed: (){
                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                          //
                          //   },
                          //   color: Color(0xFAD98C21),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(50)
                          //   ),
                          //   child: Text(
                          //     "Sign up",
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w600,
                          //         fontSize: 18
                          //     ),
                          //   ),
                          // )

                        ],
                      )



                    ],
                  );
                },
              );


            }


          },

        ),
      ),
    );
  }
}