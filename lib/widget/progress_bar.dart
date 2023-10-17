import 'dart:async';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProgressState();
  }
}

class _ProgressState extends State<ProgressBar> {
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: const Color(0xffE7E7E7),
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  _count -= 1;
                });
              },
            ),
            SizedBox(
              height: proHeight(30),
              width: proWidth(30),
            ),
            Text(_count.toString()),
            SizedBox(
              height: proHeight(30),
              width: proWidth(30),
            ),

            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _count += 1;
                });
              },
            ),
          ],
          ),
        ),
      ],
    );
  }
}