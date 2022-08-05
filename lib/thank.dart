import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laspa_ok/splash.dart';

import 'main.dart';

void main() {
  runApp(const result_page());
}



class result_page extends StatefulWidget {
  const result_page({Key? key}) : super(key: key);

  @override
  _result_pageState createState() => _result_pageState();
}

class _result_pageState extends State<result_page> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));

          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey.shade700,
              size: 30,
            ),
          )
        ],

      ),

      body:  SafeArea(

        child: Center(
          child: Column(

            children: <Widget>[
              const Text("Thank you"),

              ElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      MyApp()),
                );
              },
                  child: const Text('Card Payment'))

            ],

          ),

        ),


      ),

    );
  }
}
