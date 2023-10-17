import 'dart:convert';

import 'package:app_v2/api/community/write_article_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../../../api/community/boardimage_upload_api.dart';
import '../../../../api/community/specific_article_api.dart';
import '../../../../utils/user_secure_storage.dart';

//image related packages
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;


class WriteArticlePage extends StatefulWidget {
  const WriteArticlePage({Key? key,
  }) : super(key: key);

  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}


class _WriteArticlePageState extends State<WriteArticlePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> popUp(String text) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        title: Padding(
          padding: EdgeInsets.only(top: proHeight(25.0)),
          child: Center(
            child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: proWidth(24),
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
        actions: [
          Container(
            width: proWidth(60),
            child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15)),)
            ),
          )
        ],
      );
    }
    );
  }

  void handleArticle(int id) async {
    //GET request
    print(id);
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var a = await ArticleGetApi.getArticle(id, int.parse(userId!), jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        print(result);
        //Get 성공
        if(body['isSuccess']){
          //서버에서 board info 따와서 설정 후 화면 로드
          //빔으로 아티클 페이지로 넘김
          context.beamToNamed('/article_page', data: {'result': result, 'isNew' : true});
        }
        if (!mounted) return;
      }
      catch(e) {
        print('실패함');
        print(e.toString());
      }
    }catch(e){
      print(e);
    }
  }


  void writeArticle(String title, String text, int categoryId, List<XFile>images) async {
    setState(() {
      _titleController.text;
      _textController.text;
      _selectedCategory;
      _categoryId;
    });
    //title text category 다 있는지 확인
    if(title == ""){
      //제목을 입력해주세요
      popUp("제목을 입력해주세요");
    }
    else if(text == ""){
      //글 내용을 작성해주세요
      popUp("내용을 작성해주세요");
    }
    else{
      try{
        String? userId = await UserSecureStorage.getUserId();
        String? jwt = await UserSecureStorage.getJwt();
        //받아온
        print(jwt);
        try{
          var a= await WriteArticleApi.postArticle(
              WriteArticlePost(
                  userId: userId,
                  text: text,
                  title: title,
                  categoryId: categoryId
              ),
              jwt
          );
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          if(body['isSuccess']) {
            //사진 업로드 API 요청...
            if(images.length == 0){
              handleArticle(result[0]['boardId']);
            }
            else{
              //게시물 작성 성공, 보드 아이디로 게시물 조회 API불러서 게시물 조회
              handleImageUpload(images, result[0]['boardId']);
            }

          }else{
            print("실패함 리뷰작성");
          }
        }
        catch(e){
          print(e);
        }
      }
      catch(e){
        print(e);
      }
    }

  }

  void handleImageUpload(List<XFile> images,int boardId) async {
    dynamic sendData;
    for(int i=0; i<images.length; i++){
      int category = 1;
      if(i==0){
        category = 1;
      }
      else
        category = 2;
      try{
        var formData = dio.FormData.fromMap({
          'img': await dio.MultipartFile.fromFile(images[i].path),
        });
          var a= await BoardImageUploadApi.postBoardImage(formData, boardId, category);
          print(a);
          handleArticle(boardId);
      }catch(e){
        print(e);
        print("실패함 이미지업로드");
      }

    }
  }
  String _title = '';
  String _text = '';
  int _categoryId = 1;
  String? _selectedCategory = '032C';
  List<String> brands = ['032C','Arcteryx','Affix','Ami', 'Acne Studios','APC','Auralee','All Saints','Balenciaga','Burberry','Comme Des Garcons'
    ,'Dior','Erl','EYTYS','Essentials','Gallery Department','Givenchy','Homme Plisse Issey Miyake','Isabel Marant','Jacquemus','Juun J','Kenzo'
    ,'Lemaire','Loewe','Louis Vuitton','Maison Margiela','Martin Rose','Marni','Moncler', 'Needels','OAMC','Our Legacy','Off-white','Prada',
    'Post Archive Faction','Rick Owens','Saint Laurent','Sandro','Sporty & Rich' , 'Sunnei','Thom Browne','Wooyoungmi','Y/Project'];

  List<int> categories = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43];


  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['category'] != null){
      setState((){
        _selectedCategory = context.currentBeamLocation.state.data['category'];
      });
      for(int i=0; i<brands.length; i++){
        if(brands[i] == _selectedCategory)
          setState(() {
            _categoryId = i+1;
          });
      }
    }
  }

  //controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();


  //image picker for user upload
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final List<dio.MultipartFile> _files = [];

  //이미지 선택 함수
  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 5);
    if (images != null){
      setState((){
        _images = images;
      });
    }
    print(_images[0].path);
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
          title: Text(
            '게시글 작성하기'
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                Beamer.of(context).beamBack();
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            IconButton(
              onPressed: (){
                // parameter 확인, 카테고리 아이디 매칭 후 API 호출
                writeArticle(_title, _text, _categoryId, _images);
              },
              icon: Icon(Icons.check),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Padding(
              padding: EdgeInsets.fromLTRB(proWidth(20),0,proWidth(20),0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //사진 업로드 칸
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //사진 넣을 칸들
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Container(
                            width: proWidth(120),
                            height: proWidth(120),
                            child: Center(
                                child: (index) == 0
                                    ? IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _pickImg();
                                    });
                                  },
                                  icon: Icon(
                                    CupertinoIcons.camera,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                                    : Container(),
                            ),
                            decoration: index <= _images.length -1
                                  ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color:Colors.black),
                                  //사진 프리뷰
                                  image: DecorationImage(
                                    //정사각형 아니더라도 빈공간 없이 차도록
                                      fit: BoxFit.cover,
                                      image: FileImage(File(_images[index].path))
                                  )
                            )
                                  : BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color:Colors.black),
                            ),
                          ),
                              ),
                        )
                      ],
                    ),
                  ),
                  //제목 입력칸
                  Container(
                    height: proHeight(50),
                    child: TextField(
                      style: TextStyle(fontWeight: FontWeight.w400),
                      toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true
                      ),
                      controller: _titleController,
                      onChanged: (val) {
                        _title = _titleController.text;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: "글 제목",
                          hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                    ),
                  ),
                  //카테고리 선택 칸
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              items:
                              brands.map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                              )).toList(),
                              onChanged: (item){
                                setState(() => _selectedCategory=item);
                                for(int i=0; i<categories.length;i++){
                                  if(_selectedCategory == brands[i]){
                                    _categoryId = categories[i];
                                  }
                                }
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(5),),
                  //내용 입력
                  Container(
                    width: proWidth(480),
                    height: proHeight(380),
                    child: TextField(
                      style: TextStyle(fontWeight: FontWeight.w400),
                      toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true
                      ),
                      controller: _textController,
                      onChanged: (val) {
                        _text = _textController.text;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 16,
                      decoration: InputDecoration(
                          hintText: "글자를 입력하세요",
                          hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}