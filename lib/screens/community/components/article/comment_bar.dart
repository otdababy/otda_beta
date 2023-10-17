import 'dart:convert';

import 'package:app_v2/api/search/keyword_search_api.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../../../api/community/comment_api.dart';
import '../../../../utils/user_secure_storage.dart';

class CommentBar extends StatefulWidget {
  const CommentBar({Key? key, required this.boardId, required this.likeCount, required this.commentCount}) : super(key: key);
  final int boardId;
  final int likeCount;
  final int commentCount;

  @override
  _CommentBarState createState() => _CommentBarState(boardId: boardId, likeCount: likeCount, commentCount: commentCount);
}

class _CommentBarState extends State<CommentBar> {
  _CommentBarState({
    Key? key,
    required this.boardId,
    required this.likeCount,
    required this.commentCount
  });
  final int boardId;
  final int likeCount;
  int commentCount;

  String _commentText = '';
  //controllers
  final TextEditingController _commentController = TextEditingController();

  void comment(String commentText, boardId, ) async {
    setState(() {
      _commentController.text;
    });
    String? jwt;
    String? userId;
    try{
      userId = await UserSecureStorage.getUserId();
      jwt = await UserSecureStorage.getJwt();
      // IFF not null,
      try {
        print(commentText);
        var a = await CommentPostApi.postComment(
            CommentPost(userId: int.parse(userId!), boardId: boardId, text: commentText),
          jwt
        );
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']) {
          print("성공함 댓글작성창");
          //댓글 새로 업데이트
          setState((){
            commentCount++;
          });
          //게시물 조회 api 콜하고, 데이터 담아서 보냄...
          //context.beamToNamed('/article_page', data:{'result' : });
        }
        else{

        }
        setState(() {
          _commentController.text = '';
        });
        if(!mounted) return;
      }
      catch(e){
        print(e);
        print("실패함 댓글작성창");
      }
    }catch(e){
      print(e);
      print("댓글작성 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Padding(
          padding: EdgeInsets.all(proWidth(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.favorite, size: proWidth(15)),),
                  SizedBox(width: proWidth(3),),
                  Text(
                    likeCount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: proWidth(5),),
                  IconButton(onPressed: (){}, icon: Icon(Icons.chat_bubble, size: proWidth(15)),),
                  SizedBox(width: proWidth(3),),
                  Text(
                    commentCount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: proWidth(200),),
                  //신고하기
                ],
              ),
              SizedBox(height: proHeight(10),),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
              SizedBox(height: proHeight(10),),
              TextField(
                toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true
                ),
                keyboardType: TextInputType.text,
                controller: _commentController,
                onChanged: (val) {
                  _commentText = _commentController.text;
                },
                decoration: InputDecoration(
                  suffixIcon: Container(
                    width: proWidth(90),
                    height: proHeight(1),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        side: BorderSide(width: 1, color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){
                        comment(_commentText, boardId);
                      },
                      child: Text(
                        '작성',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),

                ),
              ),
              SizedBox(height: proHeight(10),),
            ],
          ),
        ),
      ),
    );
  }
}