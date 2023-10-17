import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  "assets/images/maincoupon.png",
];

class BannerSlider extends StatelessWidget {
  const BannerSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            items: imgList
                .map((item) => Container(
              child: Center(
                child: Image.asset(
                  item,
                  fit: BoxFit.cover,
                  width: 1000,

                ),
              ),
            ))
                .toList(),
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              viewportFraction: 1,

            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}