import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laspa_ok/onstreetparking/Profile/profilepic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Apis/api_base.dart';
import '../../Landing.dart';
import '../../authentication/login.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

late SharedPreferences localStorage;
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String AgentID;
  late String FirstName;
  late String LastName;
  late String ParkingAreaID;
  late String Email;
  late String ConcessionaireID;
  late String Location;
  late String Code;
  late String AgentCode;
  late String Name;


  final bool _isShown = true;
  bool loading = false;
  String PictureUrl = '';
  Future _delete(BuildContext context) async {
    Future.delayed(Duration.zero, () {



      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text('Please Confirm'),
              content: const Text('Are you sure???'),
              actions: [
                // The "Yes" button
                CupertinoDialogAction(
                  onPressed: () {
                    //clear the session data and redirect the user back to the logout page
                    setState(() async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      AgentID = prefs.getString('AgentID')!;
                      AgentCode = prefs.getString('AgentCode')!;
                      prefs.remove('AgentID');
                      prefs.remove('AgentCode');
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
                      Navigator.of(context,rootNavigator:true).pop();


                    });
                  },
                  child: const Text('Yes'),
                  // isDefaultAction: true,
                  // isDestructiveAction: true,
                ),
                // The "No" button
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context,rootNavigator:true).pop();
                  },
                  child: const Text('No'),
                  // isDefaultAction: false,
                  // isDestructiveAction: false,
                )
              ],
            );
          });
      setState(() => loading = false);
    });

  }



  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      AgentID = preferences.getString('AgentID')?? '';
      PictureUrl = preferences.getString('PictureUrl')?? '';

    });
  }

  Future<List<User>> getRequest() async {
    String url = Apis.AgentGetDetails;
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
    for (var singleUser in responseData) {
      User user = User(
          AgentID: singleUser["AgentID"],
          FirstName: singleUser["FirstName"],
          LastName: singleUser["LastName"],
          ParkingAreaID: singleUser["ParkingAreaID"],
          Email: singleUser["Email"],
          ConcessionaireID: singleUser["ConcessionaireID"],
          Location: singleUser["Location"],
          Code: singleUser["Code"],
          Name: singleUser["Name"],

      );

      //Adding user to the list.
      users.add(user);

      localStorage = await SharedPreferences.getInstance();
      localStorage.setString('AgentID',user.AgentID);



    }
    return users;
  }
  //String iddd ='8';



  void initial() async{
    localStorage = await SharedPreferences.getInstance();
    setState((){
      AgentID = localStorage.getString('AgentID')?? '';
      PictureUrl = localStorage.getString('PictureUrl')?? '';
    });
  }
  @override

  void initState() {
    super.initState();
    getEmail();
    //getRequest();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Color(0xffD8D8D8),
        appBar: AppBar(
          backgroundColor: Color(0xffffcc00),
          centerTitle: false,
          title: const Center(
              child: Text(
            "Profile",
            style: TextStyle(
              color: Color(0xff000000),
            ),
          )),
          elevation: 0,
        ),

        body: Column(
          children:[



            FutureBuilder(
              future: getRequest(),

              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else{

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, index) {
                      User user = snapshot.data[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                              left: kDefaultPadding,
                              right: kDefaultPadding,
                              bottom: 10,
                            ),
                            height: 160,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/LASPAo.png",
                                      height: 70,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Hello,' + user.FirstName ,

                                        style: const TextStyle(color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    Image.asset("assets/Transaction.png"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          "assets/Icon ionic-ios-notifications-outline.png"),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CircleAvatar(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                    height: 50,
                                    child: ProfilePic(
                                      image: PictureUrl,

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //tab view will be here ooo
                          SizedBox(
                            height: 2,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(28.0),
                          //   child: TextField(
                          //     style: TextStyle(
                          //
                          //       height: 0.0,
                          //
                          //     ),
                          //     decoration: InputDecoration(
                          //
                          //       enabledBorder: new OutlineInputBorder(
                          //         borderRadius: new BorderRadius.circular(10.0),
                          //         borderSide:  BorderSide(color: Colors.yellow ),
                          //
                          //       ),
                          //       focusedBorder: new OutlineInputBorder(
                          //         borderRadius: new BorderRadius.circular(25.0),
                          //         borderSide:  BorderSide(color: Colors.yellow ),
                          //
                          //       ),
                          //       filled: true,
                          //       hintStyle: TextStyle(color: Colors.white),
                          //       // hintText: "Type in your text",
                          //       fillColor: Color(0xffffffff),
                          //       suffixIcon: Icon(Icons.search),
                          //
                          //     ),
                          //   ),
                          // ),


                          // create widgets for each tab bar here
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
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
                                      child: TextField(
                                        decoration: InputDecoration(
                                          // icon: Icon(Icons.account_circle),
                                          labelText: '${user.FirstName}' +' ' +  '${user.LastName}',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          // icon: Icon(Icons.account_circle),
                                          labelText: user.Code,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          // icon: Icon(Icons.account_circle),
                                          labelText: user.Name,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );


                }

              },

            ),

            OutlinedButton(
              onPressed:(){
                _delete(context);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
              ),
              child: const Text("Log out",style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.red,
              ),),
            ),


            // OutlinedButton(
            //   onPressed:(){
            //
            //
            //     Navigator.pushReplacement(
            //         context, MaterialPageRoute(builder: (context) => ProfileMain()));
            //
            //
            //
            //     // _delete(context);
            //   },
            //   style: ButtonStyle(
            //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
            //   ),
            //   child: const Text("Profile Two",style: TextStyle(
            //     fontWeight: FontWeight.w600,
            //     fontSize: 18,
            //     color: Colors.red,
            //   ),),
            // ),
            //
            //
    ],


        ),
        ),
      );
  }
}
