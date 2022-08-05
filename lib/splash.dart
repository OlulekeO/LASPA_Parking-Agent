import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication/login.dart';
import 'scroll.dart';



void main() {
  runApp(MyHomePage());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();





}

class _MyHomePageState extends State<MyHomePage> {
  @override





  late SharedPreferences localStorage;

  String AgentCode = '';
  String AgentID = '';

  checkKey () async
  {
    localStorage = await SharedPreferences.getInstance();
    AgentCode = localStorage.getString("AgentCode") ?? "";
    AgentID = localStorage.getString("AgentID") ?? "";



    if ((AgentCode != '') && (AgentID != '')){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));

    }else{

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }

  }





  void initState() {
    super.initState();
    // checkKey();
    Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage() ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffD8D8D8),
      body: Center(
        child: Image(
          image: AssetImage("assets/LASPALOGOPNGB.png"),
         height: 400,
        ),
      ),
    );
  }
}
