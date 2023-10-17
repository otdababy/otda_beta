import 'dart:convert';
import 'package:app_v2/api/product_page_api.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewSpecificCard extends StatefulWidget {
  const ReviewSpecificCard({Key? key,
    required this.reviewId,
    required this.score,
    required this.nickName,
    required this.profileImageUrl,
    required this.size,
    required this.rentalDuration,
    required this.text,
    required this.images,
  }) : super(key: key);

  final int reviewId;
  final List<dynamic> images;
  final String text;
  final int rentalDuration;
  final int score;
  final String size;
  final String nickName;
  final String profileImageUrl;


  @override
  _ReviewSpecificCardState createState() => _ReviewSpecificCardState(images: images, size: size, rentalDuration: rentalDuration, text: text, reviewId: reviewId, score: score, profileImageUrl: profileImageUrl, nickName: nickName);
}

class _ReviewSpecificCardState extends State<ReviewSpecificCard> {
  _ReviewSpecificCardState({
    Key? key,
    required this.reviewId,
    required this.nickName,
    required this.profileImageUrl,
    required this.score,
    required this.size,
    required this.rentalDuration,
    required this.text,
    required this.images,
  }); //: super(key: key);

  final int reviewId;
  final List<dynamic> images;
  final String text;
  final int rentalDuration;
  final int score;
  final String size;
  final String nickName;
  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15,),
        Row(
          children: [
            //프로필
            CircleAvatar(
              maxRadius: 20,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(width: proWidth(5),),
            //닉네임
            Text(
              nickName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: proHeight(10),),
        //별점
        Row(
          children: [
              RatingBarIndicator(
                rating: score.toDouble(),
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                itemCount: 5,
                itemSize: proHeight(20),
                direction: Axis.horizontal,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  '(${score.toDouble()})',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),

        SizedBox(height: proHeight(5),),
        //리뷰 내용
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            text
          ),
        ),
        //사진들 업로드
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                images.length,
                    (index) => Padding(
                      padding: EdgeInsets.fromLTRB(0, proHeight(15), proWidth(10), proHeight(10)),
                      child: Container(
                        height: proHeight(120),
                        width: proWidth(120),
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(images [index]['imageUrl']),fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Expanded(child: Container(height: 1,color: Colors.grey.shade200,)),
          ],
        ),
      ],
    );
  }
}
