import 'package:app_v2/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Category extends StatelessWidget {
  Category({
    Key? key,
    required this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: proWidth(5)),
        child: SizedBox(
          height: proHeight(40),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              //padding: EdgeInsets.all(5),
              shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              backgroundColor: Colors.grey.shade200,
            ),
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500
              ) ,
            ),
          ),
        ),
    );
  }
}
