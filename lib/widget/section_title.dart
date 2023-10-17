import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';


class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: proWidth(18),
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: IconButton(
              onPressed: (){
                press;
              },
              icon: Icon(Icons.east_outlined),
              iconSize: proWidth(18),
              color: Color(0xff4E4E4E),
            ),
          ),
        ],
      ),
    );
  }
}