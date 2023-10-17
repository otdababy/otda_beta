import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Penalty extends StatefulWidget {
  @override
  PenaltyState createState() {
    return PenaltyState();
  }
}

class PenaltyState extends State<Penalty> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.beamToNamed('/home',data: {'index' : 3});
          },
          icon: Icon(Icons.west_outlined),
        ),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/htmls/penalty.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}