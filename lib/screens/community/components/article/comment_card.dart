import 'dart:convert';
import 'package:app_v2/api/product_page_api.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';

import '../../../../api/community/specific_article_api.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    Key? key,
    required this.commnetId,
    required this.userId,
    required this.nickName,
    required this.profileImageUrl,
    required this.text,
    required this.createdAt,
  }) : super(key: key);

  final int commnetId;
  final int userId;
  final String nickName;
  final String profileImageUrl;
  final String text;
  final String createdAt;


  @override
  _CommentCardState createState() => _CommentCardState(commnetId: commnetId, nickName: nickName,
      text: text, profileImageUrl: profileImageUrl, createdAt: createdAt, userId: userId, );
}

class _CommentCardState extends State<CommentCard> {
  _CommentCardState({
    Key? key,
    required this.commnetId,
    required this.userId,
    required this.nickName,
    required this.profileImageUrl,
    required this.text,
    required this.createdAt,
  });

  final int commnetId;
  final int userId;
  final String nickName;
  final String profileImageUrl;
  final String text;
  final String createdAt;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(proWidth(10), proHeight(10), proWidth(10), proHeight(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: ClipRRect(child: Image.network(profileImageUrl), borderRadius: BorderRadius.circular(proWidth(20)),),
                maxRadius: proWidth(20),
              ),
              SizedBox(width: proWidth(5),),
              Text(
                nickName,
                style: TextStyle(
                    fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          SizedBox(height: proHeight(5),),
          Row(
            children: [
              SizedBox(width: proWidth(45),),
              Text(
                text,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black
                ),
              ),
            ],
          ),
          SizedBox(height: proHeight(5),),
          Row(
            children: [
              SizedBox(width: proWidth(45),),
              Text(
                createdAt,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
