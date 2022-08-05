import 'package:flutter/material.dart';
import '../../shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../Apis/api_base.dart';
import '../Home.dart';
import '../Landing.dart';
import 'dart:io';
import 'package:flutter/services.dart';
late SharedPreferences localStorage;


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field  stateloginUser
  String agencode = '';
  String password = '';
  String error = '';
 String AgentCode = '';
  String AgentID = '';
  // checkKey () async
  // {
  //   localStorage = await SharedPreferences.getInstance();
  //   AgentCode = localStorage.getString("AgentCode") ?? "";
  //   AgentID = localStorage.getString("AgentID") ?? "";
  //
  //
  //
  //   if ((AgentCode != '') && (AgentID != '')){
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Home()));
  //
  //   }else{
  //
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => LoginPage()));
  //   }
  //
  // }

  checkKey () async
  {
    localStorage = await SharedPreferences.getInstance();
    AgentCode = localStorage.getString("AgentCode") ?? "";
    AgentID = localStorage.getString("AgentID") ?? "";


    if ((AgentCode != '') && (AgentID != '')){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Landing()));

    }else{
      print('Kinzmsh');

    }

  }



  void initState() {
    super.initState();
    checkKey();
  }

  Future <String>  loginUser() async {
    HttpClient client =  HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    String url = Apis.loginApi;
    final response = await http.post(url, body: {
      "agentcode": agencode,
      "password": password,
    });
    String responseData = json.encode(response.body);
    String message = json.decode(responseData);
    Map<String, dynamic> LoginResponse = jsonDecode(response.body);
    var responsemessage = LoginResponse['message'];

      print(responsemessage);
    if(responsemessage.contains("Parking Agent Login Successful")){

      var dataResponse =  LoginResponse['data'];
      var Code = dataResponse['Code'];
      var FirstName = dataResponse['FirstName'];
      var LastName = dataResponse['LastName'];
      var PictureUrl = dataResponse['PictureUrl'];
      var ParkingAreaID = dataResponse['ParkingAreaID'];
      var AgentID = dataResponse['AgentID'];


      // print("logging in");
      localStorage = await SharedPreferences.getInstance();
      localStorage.setString('AgentCode',Code);
      localStorage.setString('AgentID',AgentID);
      localStorage.setString('FirstName',FirstName);
      localStorage.setString('LastName',LastName);
      localStorage.setString('PictureUrl',PictureUrl);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Landing()));



    }
    else{

      setState(() {
      });
      // String message = "Invalid Agent code or Password";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(responsemessage),
            actions: <Widget>[
              FlatButton(
                child:  const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() => loading = false);
    }
    return message;

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => (true),
      child: Scaffold(
       resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Login'),
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,),


          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Form(
            key:  _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[

                        Container(
                          padding: EdgeInsets.only(top: 100),
                          height: 200,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/LASPALOGOPNGB.png"),
                                fit: BoxFit.fitHeight
                            ),

                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[


                      Text("Login",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,


                      ),),


                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(labelText: 'Agent Code'),
                          validator: (val) => val!.isEmpty ? ' Agent Code is required' : null ,
                          onChanged :(val){
                            setState(() => agencode = val);
                          }
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Password'),
                          validator: (val) => val!.length < 1 ? ' Enter a password 1+ chars long' : null ,
                          obscureText: true,
                          onChanged: (val){
                            setState(() => password = val);
                          }
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 40),
                    //   child: Column(
                    //     children: <Widget>[
                    //       inputFile(label: "Username"),
                    //       inputFile(label: "Password", obscureText: true)
                    //     ],
                    //   ),
                    // ),

                    Padding(padding:
                    EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        // padding: EdgeInsets.only(top: 3, left: 3),
                        decoration:
                        BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),

                            )



                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                            onPressed: () async {



                              if(_formKey.currentState!.validate()){
                                setState(() => loading = true);
                                //  // dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                //   if (result == null){
                                //     setState((){
                                //       error = 'please supply a valid email';
                                //       loading= false;
                                //
                                //     });
                                //
                                //   }
                                //
                                loginUser();
                              }
                            },
                          color: const Color(0xffffcc00),

                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),

                          ),

                          child: (loading)
                              ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              )):
                          const Text(
                            "Log in", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black,

                          ),
                          ),



),
    ),




                ),
              ],

          )
        ],
        ),
    ),
    ),
      ),
    );
  }
}


// we will be creating a widget for text field
Widget inputFile({label, obscureText = false})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color:Colors.black87
        ),

      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}