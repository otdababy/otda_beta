import 'package:flutter/material.dart';
import 'closet_body.dart';

class ClosetPage extends StatelessWidget {
  ClosetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ClosetBody(),
      ),
    );
  }
}
