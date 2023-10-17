import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/widget/section_title.dart';
import 'package:app_v2/classes/product/product_card.dart';

class Jacket extends StatelessWidget {
  const Jacket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "반팔",
          press: (){},
        ),
        SizedBox(height: 0.02 * MediaQuery.of(context).size.width),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [],
          ),
        ),
      ],
    );
  }
}
