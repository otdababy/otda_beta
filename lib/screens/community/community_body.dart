import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';
import '../../api/community/community_page_api.dart';
import '../../api/community/specific_article_api.dart';
import '../../utils/user_secure_storage.dart';
import 'components/article/article_card.dart';

class CommunityBody extends StatefulWidget {
  @override
  _CommunityBodyState createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<CommunityBody> {


  bool isInit = true;
  List<String> communityCategories = ['032C','Arcteryx','Affix','Ami', 'Acne Studios','APC','Auralee','All Saints','Balenciaga','Burberry','Comme Des Garcons'
    ,'Dior','Erl','EYTYS','Essentials','Gallery Department','Givenchy','Homme Plisse Issey Miyake','Isabel Marant','Jacquemus','Juun J','Kenzo'
    ,'Lemaire','Loewe','Louis Vuitton','Maison Margiela','Martin Rose','Marni','Moncler', 'Needels','OAMC','Our Legacy','Off-white','Prada',
    'Post Archive Faction','Rick Owens','Saint Laurent','Sandro','Sporty & Rich' , 'Sunnei','Thom Browne','Wooyoungmi','Y/Project'];
  List<int> categories = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43];
  String? _selectedCategory = '032C';

  //state를 set할 아이들
  List<dynamic> _result = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    loadCommunity();
  }

  void handleArticle(int id) async {
    //GET request
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var a = await ArticleGetApi.getArticle(id, int.parse(userId!), jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //서버에서 board info 따와서 설정 후 화면 로드
          //빔으로 아티클 페이지로 넘김
          context.beamToNamed('/article_page', data: {'result': result,'category' : _selectedCategory});
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

  void loadCommunity() async{
    int category = 1;
    if(context.currentBeamLocation.state.data['category']!= null){
      for(int i=0; i<communityCategories.length; i++){
        if(communityCategories[i] == context.currentBeamLocation.state.data['category']){
          setState((){
            category = i+1;
            _selectedCategory = context.currentBeamLocation.state.data['category'];
          });
          break;
        }
      }
    }
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        //게시글들 조회 API
        var a = await CommunityGetApi.getCommunity(category,int.parse(userId!),jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          // _result를 셋함
          setState((){
            _result = result;
          });
        }
      }
      catch(e) {
        print(e.toString());
      }
    }catch(e){
      print(e);
    }
  }


  void selectBoard(String selected) async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      for(int i=0; i<categories.length;i++){
        if(selected == communityCategories[i]){
          //커뮤니티 조회 API새로 호출, _result를 업데이트함
          try{
            //게시글들 조회 API
            var a = await CommunityGetApi.getCommunity(i+1,int.parse(userId!),jwt);
            final body = json.decode(a.body.toString());
            //result from GET
            final result = body['result'];
            //Get 성공
            if(body['isSuccess']){
              // _result를 셋함
              setState((){
                _result = result;
              });
            }
          }
          catch(e) {
            print(e.toString());
          }
        }
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.all(proWidth(30)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //브랜드 필터
                    Expanded(
                      child: Container(
                        child: Material(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              items:
                              communityCategories.map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,style: TextStyle(fontSize: proWidth(20), fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),)
                              )).toList(),
                              onChanged: (item){
                                setState(() => _selectedCategory=item);
                                //선택한 카테고리로 이제 화면 다시 로딩함
                                selectBoard(_selectedCategory!);
                              }
                            ),
                          ),
                        ),
                      ),
                    ),
                    //게시글 추가 버튼
                    Material(
                      child: Padding(
                        padding: EdgeInsets.all(proWidth(5)),
                        child: IconButton(onPressed: (){
                          context.beamToNamed('/write_article',data: {'category' : _selectedCategory});
                        }, icon: Icon(
                          Icons.add_box_outlined,
                        ),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: proHeight(30),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _result.length,
                    itemBuilder: (BuildContext ctx, index){
                      return GestureDetector(
                        onTap: ()=>{
                          handleArticle(_result[index]['boardId']),
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: proHeight(120),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //사진
                                Container(
                                  width: proWidth(120),
                                  height: proWidth(120),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      //정사각형 아니더라도 빈공간 없이 차도록
                                        fit: BoxFit.cover,
                                        image: (_result[index]['headImageUrl'] == '0') ? NetworkImage('https://otdabeta.s3.ap-northeast-2.amazonaws.com/OTDALOGO_SQUARE.png')
                                            : NetworkImage(_result[index]['headImageUrl'])
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Container(width: proWidth(15),),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(top: proHeight(20)),
                                        child: Text(
                                          _result[index]['title'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: proHeight(20)),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(_result[index]['profileImageUrl']),
                                              maxRadius: proWidth(15),
                                            ),
                                            SizedBox(width: proWidth(5)),
                                            Text(
                                              _result[index]['nickName'],
                                              style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            //라이크랑 커멘트
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border_rounded,
                                        size: 20,
                                      ),
                                      SizedBox(width: proWidth(5),),
                                      Text(
                                        _result[index]['likeCount'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: proWidth(15),),
                                      Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        size: 20,
                                      ),
                                      SizedBox(width: proWidth(5),),
                                      Text(
                                        _result[index]['commentCount'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
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
                  ),
                ),
              ]
            ),
          );
    }
}