import 'dart:convert';

import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../api/review/specific_review_api.dart';



class ReviewCard extends StatefulWidget {
  const ReviewCard({Key? key,
    required this.reviewId,
    required this.images,
    required this.score,
    required this.size,
    required this.rentalDuration,
    required this.text,
  }) : super(key: key);

  final int reviewId;
  final int score;
  final String size;
  final int rentalDuration;
  final String text;
  final List<dynamic> images;

  @override
  ReviewCardState createState() =>
      ReviewCardState(
          reviewId: reviewId,
          images: images,
          score: score,
          size: size,
          rentalDuration: rentalDuration,
          text: text);

}

class ReviewCardState extends State<ReviewCard> {
  ReviewCardState({Key? key,
    required this.reviewId,
    required this.images,
    required this.score,
    required this.size,
    required this.rentalDuration,
    required this.text,
  });
  final int reviewId;
  final int score;
  final String size;
  final int rentalDuration;
  final String text;
  final List<dynamic> images;

  void handleReview() async {
    try{
      var a = await SpecificReviewGetApi.getSpecificReview(reviewId);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      print(result);
      //Get 성공
      if(body['isSuccess']){
        //게시물 로딩
        context.beamToNamed('/specific_review', data: {'result': result,'reviewId':reviewId});
      }
    }
    catch(e){
      print('실패함');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //누르면 리뷰화면으로 이동,
      onTap: (){
        handleReview();
      },//context.beamToNamed(),
      child: Padding(
        padding: EdgeInsets.all(proWidth(10)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: proWidth(180),
                    height: proWidth(180),
                    decoration:
                    BoxDecoration(
                      image: DecorationImage(
                        //정사각형 아니더라도 빈공간 없이 차도록
                          fit: BoxFit.cover,
                          image: NetworkImage(images[0]['imageUrl'])
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: proHeight(15)),
              Padding(
                padding: EdgeInsets.only(left: proWidth(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        SizedBox(width: proWidth(5),),
                        Text('(${score.toString()})'),
                      ],
                    ),
                    SizedBox(height: proHeight(7)),
                    Text(
                      "사이즈: ${size}, ${rentalDuration}일 대여",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      maxLines: 2,
                    ),
                    SizedBox(height: proHeight(7)),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
