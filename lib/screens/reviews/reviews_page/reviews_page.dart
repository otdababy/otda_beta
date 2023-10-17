import 'package:app_v2/screens/reviews/reviews_page/review_specific_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../classes/product/product_card.dart';



class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key,
  }) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}


class _ReviewsPageState extends State<ReviewsPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Beamer.of(context).beamBack();
          }, icon: Icon(Icons.west_outlined),),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(proWidth(20), proHeight(20), proWidth(20), proHeight(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: proHeight(10),),
              Text(
                '리뷰 (${context.currentBeamLocation.state.data['reviewCount']})',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30
                ),
              ),
              SizedBox(height: proHeight(10),),
              Text(' 평균평점',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 18
                ),
              ),

              SizedBox(height: proHeight(1),),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: context.currentBeamLocation.state.data['avg_score'],
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    itemCount: 5,
                    itemSize: proHeight(30),
                    direction: Axis.horizontal,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '(${context.currentBeamLocation.state.data['avg_score'].toStringAsFixed(2)})',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(width: proWidth(450),height: 1,color: Colors.grey.shade200,),
              SizedBox(height: 15,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ...List.generate(
                        context.currentBeamLocation.state.data['reviews'].length,
                            (index) => ReviewSpecificCard(reviewId: context.currentBeamLocation.state.data['reviews'][index]['reviewId'],
                              score: context.currentBeamLocation.state.data['reviews'][index]['score'],
                              size: context.currentBeamLocation.state.data['reviews'][index]['size'],
                              rentalDuration: context.currentBeamLocation.state.data['reviews'][index]['rentalDuration'],
                              text: context.currentBeamLocation.state.data['reviews'][index]['text'],
                              images: context.currentBeamLocation.state.data['reviews'][index]['images'],
                              nickName: context.currentBeamLocation.state.data['reviews'][index]['nickName'],
                              profileImageUrl: context.currentBeamLocation.state.data['reviews'][index]['profileImageUrl'],)
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}