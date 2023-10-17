import 'package:app_v2/screens/search/components/recommend/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Recommend extends StatelessWidget {
  Recommend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Brand(
                text: "Maison Kitsune",
                press: (){}
          ),
          Brand(
              text: "Dior",
              press: (){}
          ),
          Brand(
              text: "Maison Margiela",
              press: (){}
          ),
          Brand(
              text: "Gallery Dept.",
              press: (){}
          ),
          Brand(
              text: "Bottega Veneta",
              press: (){}
          ),
          Brand(
              text: "Jacquemus",
              press: (){}
          ),
          Brand(
              text: "니트",
              press: (){}
          ),
          Brand(
              text: "바지",
              press: (){}
          ),
        ],
      ),
    );
  }

}