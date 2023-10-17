import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/widget/section_title.dart';
import 'package:app_v2/classes/product/product_card.dart';

import '../../../../utils/size_config.dart';

class Trending extends StatelessWidget {
  final List<dynamic> result;
  const Trending(this.result);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: proWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trending",
                    style: TextStyle(
                        fontSize: proWidth(18),
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  Text("지금 뜨는 상품은",
                    style: TextStyle(
                        fontSize: proWidth(12),
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: ((){
                  context.beamToNamed('/trending',data: {'result':result});
                }),
                child: IconButton(
                  onPressed: (){
                    context.beamToNamed('/trending',data: {'result':result});;
                  },
                  icon: Icon(Icons.east_outlined),
                  iconSize: proWidth(18),
                  color: Color(0xff4E4E4E),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: proHeight(10)),
        Padding(
          padding: EdgeInsets.only(right: proWidth(20)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  result.length,
                      (index) => Container(
                        width: proWidth(200),
                        height: proHeight(350),
                        child: ProductCard(
                    productId: result[index]['productId'],
                          imageUrl: result[index]['imageUrl'],
                    defaultPrice: result[index]['defaultPrice'],
                    productName: result[index]['productName'],
                    brandName: result[index]['brandName'],
                  ),
                      ),
                ),
                ],
            ),
          ),
        ),
      ],
    );
  }
}
