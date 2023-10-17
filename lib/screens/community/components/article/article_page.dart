import 'dart:convert';

import 'package:app_v2/api/community/like_api.dart';
import 'package:app_v2/screens/community/community_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import '../../../../api/community/comment_api.dart';
import '../../../../api/community/delete_board_api.dart';
import '../../../../api/community/delete_comment_api.dart';
import '../../../../api/community/specific_article_api.dart';
import '../../../../utils/user_secure_storage.dart';
import '../../../../utils/size_config.dart';


class ArticlePage extends StatefulWidget {

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {


  //바뀌어야할 state들
  Widget heart = Icon(Icons.favorite_border, size: proWidth(15));
  bool isInit = true;
  int likeCount = 0;
  int commentCount = 0;
  List<dynamic> _result = [];
  String _commentText = '';
  bool isLike = false;
  //controllers
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState(){
    super.initState();
    isInit = true;
  }

  @override
  void didChangeDependencies(){
    if(isInit) {
      setState((){
        isInit =false;
      });
      loadBoard();
      if (context.currentBeamLocation.state.data['result'][0]['isLike']) {
        setState(() {
          heart = Icon(Icons.favorite, size: proWidth(15));
          isLike = true;
        });
      }
      likeCount =
      context.currentBeamLocation.state.data['result'][0]['likeCount'];
      commentCount =
      context.currentBeamLocation.state.data['result'][0]['commentCount'];
      print(commentCount);
    }
  }

  void loadBoard() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var a = await ArticleGetApi.getArticle(context.currentBeamLocation.state.data['result'][0]['boardId'],int.parse(userId!),jwt );
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //print(result[0]['commentCount']);
        //Get 성공
        if(body['isSuccess']){
          //게시물 로딩
          setState((){
            _result = result;
          });
        }
      }
      catch(e) {
        print('실패함');
        print(e.toString());
      }
    }catch(e){
      print(e);
    }
  }

  void handleLike() async {
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      // IFF not null,
      try {
        var a = await LikeApi.like(jwt,userId,context.currentBeamLocation.state.data['result'][0]['boardId']);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']) {
          //라이크 반대로
          setState((){
            isLike = !isLike;
            if(isLike){
              heart = Icon(Icons.favorite, size: proWidth(15));
              likeCount++;
            }
            else{
              heart = Icon(Icons.favorite_border, size: proWidth(15));
              likeCount--;
            }
          });
        }
        else{
        }
        if(!mounted) return;
      }
      catch(e){
        print(e);
        print("댓글 삭제 실패");
      }
    }catch(e){
      print(e);
      print("댓글삭제 실패");
    }
}

  void deleteComment(int commentId) async {
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      // IFF not null,
      try {
        print(context.currentBeamLocation.state.data['result'][0]['boardId']);
        var a = await DeleteCommentApi.deleteComment(jwt,userId,commentId);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if(body['isSuccess']) {
          //게시물 정보 업데이트
          try{
            var a = await ArticleGetApi.getArticle(context.currentBeamLocation.state.data['result'][0]['boardId'], int.parse(userId!), jwt);
            final body = json.decode(a.body.toString());
            //result from GET
            final result = body['result'];
            print(result);
            //Get 성공
            if(body['isSuccess']){
              //댓글 새로 업데이트
              setState((){
                commentCount--;
                _result = result;
              });
            }
          }
          catch(e) {
            print('실패함');
            print(e.toString());
          }
        }
        else{
          if(body['code'] == 2003){
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset('assets/images/warning.png',
                        height: proHeight(100),
                        width: proHeight(100),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('댓글을 삭제할\n권한이 없습니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: proWidth(23),
                            ) ,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                    fontSize: proWidth(15)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
                }
            );
          }
        }
        if(!mounted) return;
      }
      catch(e){
        print(e);
        print("댓글 삭제 실패");
      }
    }catch(e){
      print(e);
      print("댓글삭제 실패");
    }
  }

  void delete() async {
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      // IFF not null,
      try {
        print(jwt);
        print(userId);
        print(context.currentBeamLocation.state.data['result'][0]['boardId']);
        var a = await DeleteBoardApi.deleteBoard(jwt,userId,context.currentBeamLocation.state.data['result'][0]['boardId']);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']) {
          print("성공함 게시글 지우기");
          //게시물 조회 후 댓글 정보 받아옴...
          context.beamToNamed('/home',data: {'index' : 2,  'category': context.currentBeamLocation.state.data['category']});
        }
        else{
          if(body['code'] == 2003){
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset('assets/images/warning.png',
                        height: proHeight(100),
                        width: proHeight(100),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('게시글을 삭제할\n권한이 없습니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: proWidth(23),
                            ) ,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
                }
            );
          }
        }
        if(!mounted) return;
      }
      catch(e){
        print(e);
        print("게시글 삭제 실패");
      }
    }catch(e){
      print(e);
      print("글삭제 실패");
    }
  }

  void comment(String commentText, boardId) async {
    setState(() {
      _commentController.text;
    });

    if(commentText != ""){
      String? jwt;
      String? userId;
      try{
        userId = await UserSecureStorage.getUserId();
        jwt = await UserSecureStorage.getJwt();
        // IFF not null,
        try {
          print(commentText);
          print(boardId);
          var a = await CommentPostApi.postComment(
              CommentPost(userId: int.parse(userId!), boardId: boardId, text: commentText),
              jwt
          );
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          if(body['isSuccess']) {
            print("성공함 댓글작성창");
            //게시물 조회 후 댓글 정보 받아옴...
            try{
              var a = await ArticleGetApi.getArticle(boardId, int.parse(userId), jwt);
              final body = json.decode(a.body.toString());
              //result from GET
              final result = body['result'];
              //Get 성공
              if(body['isSuccess']){
                //댓글 새로 업데이트
                setState((){
                  commentCount++;
                  _result = result;
                  FocusScope.of(context).unfocus();
                });
              }
            }
            catch(e) {
              print('실패함');
              print(e.toString());
            }
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              context.beamToNamed('/home', data: {'index': 2, 'category': context.currentBeamLocation.state.data['category']});
            },
            icon: Icon(Icons.west_outlined),
          ),
        ),
        bottomSheet: SingleChildScrollView(
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
                      IconButton(onPressed: (){handleLike();}, icon: heart,),
                      Text(
                        likeCount.toString(),
                        style: TextStyle(
                          fontSize: proWidth(18),
                        ),
                      ),
                      SizedBox(width: proWidth(2),),
                      IconButton(onPressed: null, icon: Icon(Icons.chat_bubble, size: proWidth(15)),),
                      Text(
                        commentCount.toString(),
                        style: TextStyle(
                          fontSize: proWidth(18),
                        ),
                      ),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontWeight: FontWeight.w400),
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
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: (){
                          comment(_commentText, _result[0]['boardId']);
                        },
                        child: Text(
                          '작성',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(10),),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.fromLTRB(proWidth(20), proHeight(20), proWidth(20), proHeight(120)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _result[0]['title'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black
                      ),
                    ),
                    Material(child: IconButton(onPressed:() async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Image.asset('assets/images/warning.png',
                                  height: proHeight(100),
                                  width: proHeight(100),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('이 게시글을 삭제하시겠습니까?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: proWidth(22),
                                      ) ,
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          delete();
                                        },
                                        child: Text('삭제하기',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: proWidth(15),
                                          ),
                                        ),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          backgroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('취소',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: proWidth(15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    }, icon: Icon(Icons.delete_outline_rounded, size: proWidth(20)),)),
                  ],
                ),
                SizedBox(height: proHeight(10),),
                //프로필 이랑 이름이랑 쓴 날짜
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_result[0]['profileImageUrl']),
                      maxRadius: proWidth(20),
                    ),
                    SizedBox(width: proWidth(15),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _result[0]['nickName'],
                          style: TextStyle(
                              fontSize: 12  ,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          _result[0]['createdAt'],
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: proHeight(10),),
                Row(
                  children : [
                    Expanded(
                        child: Container(height: 1,color: Colors.grey.shade200,)
                    ),
                  ]
                ),
                SizedBox(height: proHeight(15),),
                //이미지 사진들
                Column(
                    children: [
                      ...List.generate(
                          _result[0]['images'].length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(vertical: proHeight(10)),
                                child: FittedBox(
                            child: Image.network(_result[0]['images'][index]['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                              )
                      ),
                    ]
                ),
                SizedBox(height: 15,),
                Text(
                  _result[0]['text'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(height: proHeight(15),),
                //댓글들
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    children: [
                      ...List.generate(
                          _result[0]['comments'].length,
                              (index) => Padding(
                                padding: EdgeInsets.fromLTRB(proWidth(10), proHeight(5), proWidth(10), proHeight(10)),
                                child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(_result[0]['comments'][index]['profileImageUrl']),
                                          maxRadius: proWidth(20),
                                        ),
                                        Container(width: proWidth(15),),
                                        Text(
                                          _result[0]['comments'][index]['nickName'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        IconButton(onPressed:() async {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: Image.asset('assets/images/warning.png',
                                                  height: proHeight(100),
                                                  width: proHeight(100),
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text('이 댓글을 삭제하시겠습니까?',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: proWidth(23),
                                                      ) ,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          shape: StadiumBorder(),
                                                          backgroundColor: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          deleteComment(_result[0]['comments'][index]['commnetId']);
                                                        },
                                                        child: Text('삭제하기',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                            fontSize: proWidth(15),
                                                          ),
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          shape: StadiumBorder(),
                                                          backgroundColor: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('취소',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.white,
                                                            fontSize: proWidth(15),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          );
                                          }, icon: Icon(Icons.delete, size: proWidth(15)),),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: proWidth(55)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _result[0]['comments'][index]['text'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black
                                            ),
                                          ),
                                          SizedBox(height: proHeight(5),),
                                          Text(
                                            _result[0]['comments'][index]['createdAt'],
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: proHeight(50),),
              ],
            ),
          ),
        )
      ),
    );
  }
}