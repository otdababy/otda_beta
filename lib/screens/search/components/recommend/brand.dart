import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Brand extends StatelessWidget {
  Brand({
    Key? key,
    required this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
  }
}