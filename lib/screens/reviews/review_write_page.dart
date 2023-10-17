import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beamer/beamer.dart';

import '../../api/review/image_upload_api.dart';
import '../../api/review/review_write_api.dart';
import '../../api/review/specific_review_api.dart';
import '../../utils/user_secure_storage.dart';

import 'dart:io' as io;
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;


class ReviewWritePage extends StatefulWidget {
  const ReviewWritePage({Key? key,
  }) : super(key: key);

  @override
  _ReviewWritePageState createState() => _ReviewWritePageState();
}


class _ReviewWritePageState extends State<ReviewWritePage> {


  void popUp(String text) async{
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
                      Navigator.of(context).pop();
                    },
                    child: Text('확인', style: TextStyle(fontWeight: FontWeight.w800,fontSize: proWidth(15)),)
                ),
              )
            ],
          );
        }
    );
  }

  void handleWriteReview(String _reviewText, double _score, int rentalRequestId, List<XFile>images) async {
    setState(() {
      _reviewController.text ;
    });
    if(_score == 0.0){
      popUp("평점을 매겨주세요");
    }
    if(_reviewText == ""){
      popUp("내용을 작성해주세요");
    }
    String? userId;
    String? jwt;
    try{
      //userId = await UserSecureStorage.getUserId();
      jwt = await UserSecureStorage.getJwt();
      print(jwt);
      //주어진 정보로 api 요청
      try{

        var a= await ReviewWriteApi.postReview(
            ReviewWritePost(text: _reviewText, rentalRequestId: rentalRequestId, score: _score),
            jwt);
        final body = json.decode(a.body);
        print(body);
        final result = body['result'];
        if(body['isSuccess']){
          print('성공함 리뷰작성');
          //사진 업로드 API요청...
          print(images);
          if(images.length == 0){
            print("??");
            print(result[0]['reviewId']);
            handleSpecificReview(result[0]['reviewId']);
          }
          else{
            handleImageUpload(images, result[0]['reviewId']);
          }

        }
      }catch(e){
        print(e);
        print("실패함 리뷰작성");
      }
    }catch(e){
      print(e);
      print("실패함 리뷰작성");
    }
  }

  //스코어랑 리뷰텍스트 받아올 controller
  final TextEditingController _reviewController = TextEditingController();
  String _reviewText = "";
  double _score = 0;
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
  }

  void handleSpecificReview(int reviewId) async {
    try{
      print(reviewId);
      print(reviewId.runtimeType);
      var a = await SpecificReviewGetApi.getSpecificReview(reviewId);
      final body = json.decode(a.body.toString());
      print(body);
      final result = body['result'];
      if(body['isSuccess']){
        //정보 넣고 상세 리뷰페이지로 빔
        context.beamToNamed('/specific_review',data:{'result':result, 'isNew' : true});
      }
      else{
        print("실패함 리뷰상세페이지");
      }

    }catch(e){
      print(e);
    }
  }

  void handleImageUpload(List<XFile> images,int reviewId) async {
    //images에서 하나씩 받아서 하나씩 api 요청함
    print("리뷰포스트 성공 사진으로 들어옴");
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
        var a= await ImageUploadApi.postReviewImage(formData, reviewId, category);
        print(a);
        //리뷰페이지로감
        handleSpecificReview(reviewId);
        if (!mounted) return;

      }catch(e){
        print(e);
        print("실패함 이미지업로드");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('리뷰',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22
            ),
          ),
          leading: IconButton(
              onPressed: (){
                Beamer.of(context).beamBack();
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Padding(
              padding: EdgeInsets.fromLTRB(proWidth(40), proHeight(20), proWidth(40), 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: proHeight(10),),
                  Text(
                    context.currentBeamLocation.state.data['productName'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: proHeight(20),),
                  RatingBar.builder(
                    //initialRating: null,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    onRatingUpdate: (score) {
                      _score=score;
                    },
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text(
                        '후기를 작성해 주세요',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  //후기 작성시 포인트 어쩌구
                  SizedBox(height: proHeight(15),),
                  //후기 들어가는 칸
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: proHeight(150),
                          child: TextField(
                              toolbarOptions: const ToolbarOptions(
                                  copy: true,
                                  cut: true,
                                  paste: true,
                                  selectAll: true
                              ),
                              controller: _reviewController,
                              onChanged: (val) {
                                _reviewText = _reviewController.text;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: 7,
                              decoration: InputDecoration(
                                hintText: "글자를 입력하세요",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.grey)
                                )
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(20),),
                  Row(
                    children: [
                      Text(
                        '사진을 올려주세요',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(8),),
                  //사진후기 작성시 어쩌구
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: proHeight(30),
                            child: Center(
                              child: Text(
                                '사진 후기 작성 시 500p 추가 지급',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(8),),
                  //사진 들어가는 칸
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
                                    _pickImg();
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
                                      image: FileImage(io.File(_images[index].path))
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
                  SizedBox(height: proHeight(20),),
                  //작성완료 버튼
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: proHeight(35),
                          child: TextButton(
                              onPressed: (){
                                //리뷰작성 API요청
                                handleWriteReview(_reviewText, _score, context.currentBeamLocation.state.data['rentalRequestId'],_images);
                                },
                              child: Text(
                                '작성 완료',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                ),
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                backgroundColor: Colors.black,
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}