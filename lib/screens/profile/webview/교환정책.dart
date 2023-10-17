import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Privacy extends StatefulWidget {
  @override
  PrivacyState createState() {
    return PrivacyState();
  }
}

class PrivacyState extends State<Privacy> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Beamer.of(context).beamBack();
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
    String fileText = await rootBundle.loadString('assets/htmls/privacy.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}