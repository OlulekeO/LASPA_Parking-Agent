import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Color(0xFAD98C21),
        automaticallyImplyLeading: false,
        title: Text('Landing'),
        centerTitle: true,

      ),
      body: GridView.count(crossAxisCount: 2,
        children: <Widget> [
           Container(

            child: GestureDetector(

              onTap: (){


              },
              child: Card(
                elevation: 10.0,

                child:  Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/icons8-parking-ticket-100.png",

                      ),
                      height: 150.0,
                      width:200.0,
                      fit: BoxFit.cover,

                    ),

                     SizedBox(
                      height: 5.0,
                    ),

                    new Text("Print Ticket",

                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.orange,
                      ),

                    ),

                  ],

                ),

              ),

            ),
          ),

          Container(

            child: GestureDetector(

              onTap: (){


              },
              child: new Card(
                elevation: 10.0,

                child:  Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/icons8-order-history-60.png",

                      ),
                      height: 150.0,
                      width:200.0,
                      fit: BoxFit.cover,

                    ),

                    new SizedBox(
                      height: 5.0,
                    ),

                    new Text("Transaction History",

                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.orange,
                      ),

                    ),

                  ],

                ),

              ),

            ),
          ),

          new Container(

            child: GestureDetector(

              onTap: (){


              },
              child: new Card(
                elevation: 10.0,

                child: new Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/icons8-wireless-cloud-access-128.png",

                      ),
                      height: 150.0,
                      width:200.0,
                      fit: BoxFit.cover,

                    ),

                    new SizedBox(
                      height: 5.0,
                    ),

                    new Text("Synchronise Data (Online)",

                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.orange,
                      ),

                    ),

                  ],

                ),

              ),

            ),
          ),

          new Container(

            child: GestureDetector(

              onTap: (){


              },
              child: new Card(
                elevation: 10.0,

                child: new Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/icons8-report-64.png",

                      ),
                      height: 150.0,
                      width:200.0,
                      fit: BoxFit.cover,

                    ),

                    new SizedBox(
                      height: 5.0,
                    ),

                    new Text("Report Mgt",

                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.orange,
                      ),

                    ),

                  ],

                ),

              ),

            ),
          ),

          new Container(

            child: GestureDetector(

              onTap: (){


              },
              child: new Card(
                elevation: 10.0,

                child: new Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/free-settings-icon-3110-thumb.png",

                      ),
                      height: 150.0,
                      width:200.0,
                      fit: BoxFit.cover,

                    ),

                    new SizedBox(
                      height: 5.0,
                    ),

                    new Text("Settings",

                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.orange,
                      ),

                    ),

                  ],

                ),

              ),

            ),
          ),

          new Container(

            child: GestureDetector(

              onTap: (){


              },
              child: new Card(
                elevation: 10.0,

                child: new Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/377-3770478_faq-icon-faq-hd-png-download.png",

                      ),
                      height: 150.0,
                      width:200.0,
                      fit: BoxFit.cover,

                    ),

                    new SizedBox(
                      height: 5.0,
                    ),

                    new Text("FAQ",

                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.orange,
                      ),

                    ),

                  ],

                ),

              ),

            ),
          ),



        ],
      ),

      drawer: Drawer(
        child: ListView(

          children: <Widget>[
            DrawerHeader(child: Text('Thiusnis th header')),

            ListTile(

              title: Text('This header2'),
            ),
            ListTile(

              title: Text('This header2'),
            ),
            ListTile(

              title: Text('This header2'),
            ),

          ],

        ),

      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ('Home'),


          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: ('Print'),

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ('Profile'),


          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,

      ),

    );
  }
}
