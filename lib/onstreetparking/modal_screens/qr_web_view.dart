import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';





class load_Qr extends StatefulWidget {

  String url = '';

  load_Qr(this.url);

  // const cardPayment({Key? key}) : super(key: key);

  @override
  _load_QrState createState() => _load_QrState(this.url);
}

class _load_QrState extends State<load_Qr> {

  var _url;
  final _key = UniqueKey();

  _load_QrState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
