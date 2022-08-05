import 'package:flutter/material.dart';

import 'HomePage/Home.dart';
import 'Profile/Profile.dart';
import 'Support/Support.dart';
import 'Transactions/transactions2.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List <Widget> _widgetOptions = <Widget>[

    Text('Home'),
    Text('Transactions'),
    Text('Support'),
    Text('Profile'),
  ];

  void _onItemTap(int index ){
    setState(() {
      _selectedIndex = index;
    });
  }
  static const List<Widget> _pages = <Widget>[

    HomePage(),
    Transactions(),
    Support(),
    Profile(),

  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange[100],
        // appBar: AppBar(
        //   backgroundColor: Color(0xffffcc00),
        //   automaticallyImplyLeading: false,
        //   title: Text('Dashboard'),
        //   centerTitle: true,
        //
        // ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),


        bottomNavigationBar: BottomNavigationBar(

          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              backgroundColor: Color(0xff121425),
              icon: ImageIcon(
                AssetImage("assets/home1.png"),
                color: Color(0xFFffffff),
              ),
              label: ('Home'),


            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xff121425),
              icon: ImageIcon(
                AssetImage("assets/Car.png"),
                color: Color(0xFFffffff),
              ),
              label: ('Transactions'),

            ),

            BottomNavigationBarItem(
              backgroundColor: Color(0xff121425),
              icon: ImageIcon(
                AssetImage("assets/Icon material-headset-mic.png"),
                color: Color(0xFFffffff),
              ),
              label: ('Support'),


            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xff121425),
                icon: ImageIcon(
                  AssetImage("assets/user1.png"),
                  color: Color(0xFFffffff),
                ),
              label: ('Profile'),


            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,

        ),

      ),
    );
  }
}
class CallsPage extends StatefulWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  _CallsPageState createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(


      child: Text("thankss"),
    );
  }
}
