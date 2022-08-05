import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _ReceiptQrcode(context) {

    Alert(

      context: context,
      // title: "Receipt",
      buttons: [],
      content: Column(

        children: <Widget>[
          // SizedBox(
          //   height: 20,
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 1.0),
            height: 200,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 90,
              child: Image.asset(
                "assets/VI.png",
                height: 600,
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Phone Number',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              // icon: Icon(Icons.account_circle),
              labelText: 'Plate Number',
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[




              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: MaterialButton(
                    // minWidth: double.infinity,
                    height: 30,
                    color: Color(0xffFFF5CC),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(

                      // side: BorderSide(
                      //     color: Colors.black
                      // ),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      "www.Pranpay.com",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(

                child:  MaterialButton(
                  // minWidth: double.infinity,
                  height: 30,

                  color: Color(0xffffcc00),
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  // defining the shape
                  shape: RoundedRectangleBorder(

                    // side: BorderSide(
                    //     color: Colors.black
                    // ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "PushLink",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

            ],
          ),


        ],
      ),

    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

