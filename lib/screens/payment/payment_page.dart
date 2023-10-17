import 'dart:convert';
import 'package:app_v2/api/payment/default_address_api.dart';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../api/coupon/coupon_api.dart';
import '../../api/coupon/use_coupon_api.dart';
import '../../api/payment/add_address_api.dart';
import '../../api/payment/address_page_api.dart';
import '../../api/payment/delete_address_api.dart';
import '../../api/payment/rent_api.dart';
import '../../api/payment/set_default_address_api.dart';
import '../../api/receipt/receipt_api.dart';
import '../../utils/user_secure_storage.dart';
import 'package:intl/intl.dart';


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  _PaymentPageState({Key? key});

  @override
  void initState(){
    print("결제페이지 이닛스테이트 시작함");
    super.initState();
  }

  //states update
  List<dynamic> _result = [];
  List<dynamic> _addresses = [];
  List<dynamic> _usableCoupon = [];
  List<dynamic> _expiredCoupon = [];

  int _totalPrice = 0;
  int _totalDelivery = 0;
  int _totalPay = 0;
  bool _ischecked1 = false;
  bool _ischecked2 = false;


  //쿠폰관련 state들
  int _selectedId = 0;
  int _salePrice = 0;
  int _couponUserConnectionId = 0;
  List<bool> _couponCheck = [];
  Widget couponDelete = Text("");

  // 배송지 관련 state들
  int _addressId = 0;
  String _name = "";
  String _phoneNumber = "";
  String _address = "";
  String _detailAddress = "";
  String _requestText = "";


  TextEditingController _textController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numController = TextEditingController();
  TextEditingController _detailAddressController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  //반납지 관련 state들
  String _readdress = "";
  String _redetailAddress = "";
  TextEditingController _readdressController = TextEditingController();
  TextEditingController _redetailAddressController = TextEditingController();
  void didChangeDependencies(){
    setState((){
      _result = context.currentBeamLocation.state.data['result'];
      for(int i=0; i<_result.length; i++){
        _totalPrice = (_totalPrice + _result[i]['defaultPrice']+(_result[i]['optionPrice']*(_result[i]['rentalDuration']-3))) as int;
        _totalPay = _totalPrice;
      }
      defaultAddress();
      getAddress();
      getCoupons();
    });
  }

  void message(String text) async {
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
                    child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15),),)
                ),
              )
            ],
          );
        }
    );
  }

  void getCoupons() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await CouponGetApi.getCoupon(userId, jwt);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if (body['isSuccess']) {
          //현재 날짜 받아와서 날짜 비교 후 각각 list에 넣음
          var _toDay = DateTime.now();
          for(int i=0; i<result.length; i++){
            String expiryDate = result[i]['expiryDate'].replaceAll('/','-');
            int difference = int.parse(
                _toDay.difference(DateTime.parse(expiryDate)).inDays.toString());
            if(difference > 0){
              setState(() {
                _expiredCoupon.add(result[i]);
              });
            }
            else{
              setState(() {
                _usableCoupon.add(result[i]);
              });
            }
          }
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void defaultAddress() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await DefaultAddressGetApi.getDefaultAddress(userId, jwt);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          if(result.length == 0){
            setState(() {
              _name = "";
              _nameController.text = _name;
            });
          }
          else{
            String fulladd = result[0]['address'];
            String mainadd = fulladd.substring(0,fulladd.indexOf("\n"));
            String detailadd = fulladd.substring(fulladd.indexOf("\n")+1);
            setState((){
              _name = result[0]['name'];
              _addressId = result[0]['addressId'];
              _address = mainadd;
              _requestText = result[0]['requestText'];
              _textController.text = result[0]['requestText'];
              _phoneNumber = result[0]['phoneNumber'];
              _nameController.text = _name;
              _numController.text = _phoneNumber;
              _addressController.text = mainadd;
              _readdress = mainadd;
              _readdressController.text = mainadd;
              _detailAddress = detailadd;
              _detailAddressController.text = detailadd;
              _redetailAddress = detailadd;
              _redetailAddressController.text = detailadd;
            });
          }
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void getAddress() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await AddressGetApi.getAddress(userId, jwt);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if (body['isSuccess']) {
          setState((){
            _addresses = result[0]['address'];
          });
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void addAddress(String name, String address, String phoneNumber, String requestText, String detailAddress) async {
    if(name=="" || address == "" || phoneNumber == "" || detailAddress == ""){
      message("모든 정보를 넣어주세요!");
    }
    String text = requestText;
    if (text == ""){
      text = "안전하게 배송해주세요!";
    }
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      int isDef = 0;
      if(_addresses.length > 0){
        isDef=1;
      }
      try {
        var a = await AddressPostApi.postAddress(userId, jwt, name, address+"\n"+detailAddress, phoneNumber, text, isDef);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if (body['isSuccess']) {
          //추가된 주소 업데이트
          setState((){
            getAddress();
          });
          message("배송지가 저장되었습니다!");
        }
        else{
          message("올바른 정보를 넣어주세요!");
        }
      }catch(e){
        print(e);
        message("다시 시도해주세요!");
      }
    }catch(e){
      print(e);
      message("다시 시도해주세요!");
    }
  }

  void setDefaultAddress(int addressId) async{
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await SetDefaultAddressApi.setDefaultAddress(userId, jwt, addressId);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          //default address 업데이트 됐음
          message("기본 배송지가 업데이트 되었습니다!");
        }
      }catch(e){
        print(e);
        message("다시 시도해주세요!");
      }
    }catch(e){
      print(e);
      message("다시 시도해주세요!");
    }
  }

  void deleteAddress(int addressId) async {
    try {
          String? userId = await UserSecureStorage.getUserId();
          String? jwt = await UserSecureStorage.getJwt();
          //받아온
          try {
            var a = await AddressDeleteApi.deleteAddress(userId, jwt, addressId);
            final body = json.decode(a.body.toString());
            print(body);
            final result = body['result'];
            if (body['isSuccess']) {
              //삭제된 주소록 업데이트
              setState((){
                getAddress();
              });
              message("배송지가 삭제되었습니다");
            }
          }catch(e){
            print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void handleReceipt(int orderId) async{
    try{
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 패치실행
      try{
        var a = await ReceiptGetApi.getReceipt(orderId, jwt );
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //지우는거 성공함 -> 화면 리로드
          context.beamToNamed('/payment_complete',data: {'result' : result[0],'orderId' : orderId});
        }
      }
      catch(e) {
        print(e.toString());
      }
    }catch(e){
      print(e);
    }
  }

  void popUp(String title, String text, String image, String next, int orderId) async {
    await showDialog(
        context: context,
        builder: (BuildContext context)
    {
      return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(image,
            height: proHeight(100),
            width: proHeight(100),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: proWidth(22),
                ),
              ),
              SizedBox(height: proHeight(5),),
              Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: proWidth(15),
                  fontWeight: FontWeight.w400,
                  color: Color(0xff4E4E4E),
                ),
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
                  onPressed: () async {
                    Navigator.pop(context);
                    await showDialog(
                        context: context,
                        builder: (BuildContext context)
                    {
                      return AlertDialog(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Image.asset('assets/images/세탁금지.png',
                            height: proHeight(100),
                            width: proHeight(100),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('따로 세탁은 하지 말아주세요!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: proWidth(24),
                                ),
                              ),
                              SizedBox(height: proHeight(5),),
                              Text('세탁으로 인한 손상 시 손상액이 청구 될 수 있습니다',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: proWidth(18),
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff4E4E4E),
                                ),
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
                                  },
                                  child: Text('취소',
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
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context)
                                    {
                                      return AlertDialog(
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Image.asset('assets/images/문앞택배.png',
                                            height: proHeight(100),
                                            width: proHeight(100),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('반납일 전날 밤, 문 앞에 둬주세요!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: proWidth(24),
                                                ),
                                              ),
                                              SizedBox(height: proHeight(5),),
                                              Text('배송됐던 박스에 큰 글씨로 "옷다"를 적은 후 문 앞에 둬주세요',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: proWidth(18),
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff4E4E4E),
                                                ),
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
                                                    handleReceipt(orderId);
                                                  },
                                                  child: Text('완료',
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
                                    });
                                  },
                                  child: Text('다음',
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
                    });
                  },
                  child: Text(next,
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
    });
  }

  void handlePay() async{
    if (_requestText == ""){
      _requestText = "안전하게 배송해주세요!";
    }
    if(_address == ""){
      message("주소를 입력해주세요");
    }
    else if(_name == ""){
      message("이름을 입력해주세요");
    }
    else if(_phoneNumber == ""){
      message("번호를 입력해주세요");
    }
    else if(_readdress == "" || _redetailAddress == ""){
      message("반납장소를 입력해주세요");
    }
    else if(_detailAddress == ""){
      message("상세주소를 입력해주세요");
    }
    else{
      try {
        String? userId = await UserSecureStorage.getUserId();
        String? jwt = await UserSecureStorage.getJwt();

        //instanceID, rentalduration 확인
        List<int> instanceId = [];
        List<int> rentalDuration = [];
        for(int i=0; i<_result.length; i++){
          instanceId.add(_result[i]['instanceId']);
        }
        for(int i=0; i<_result.length; i++){
          rentalDuration.add(_result[i]['rentalDuration']);
        }

        try {
          var a = await RentApi.postRent(userId, jwt, _result.length, _couponUserConnectionId,_totalPay,0,0,0,
              _requestText,_name,_phoneNumber,_address+" "+_detailAddress, _readdress+"\n"+_redetailAddress, instanceId, rentalDuration);
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          if (body['isSuccess']) {
            //리퀘스트 완료, 결제완료 페이지로 이등,
            popUp('결제가 완료됐습니다!', '이제 배송 후 절차를 안내드리겠습니다', 'assets/images/배송택배박스.png', '다음',result[0]['orderId']);
          }
          else{
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
                        child: Text('결제가 실패하였습니다.\n다시 시도해주세요',
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
                            child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(16)),)
                        ),
                      )
                    ],
                  );
                }
            );
          }
        }catch(e){
          print(e);
        }
      }catch(e){
        print(e);
      }
    }
  }

  void useCoupon(int id, int salePrice) async{
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await UseCouponApi.useCoupon(userId, jwt, id);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          //쿠폰 사용성공함 팝업 띄우면된다, 쿠폰함에서 지우고 결제화면에 반영
          setState((){
            getCoupons();
            //_couponPrice = salePrice;
          });
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    setState(() {
      _addressController.text = '${model.zonecode!} ${model.address!} ${model.buildingName!}';
      _address = _addressController.text;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Beamer.of(context).beamBack();
          },
          icon: Icon(Icons.west_outlined),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  '  총 ${_result.length}개의 상품',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    color: Colors.black
                  ),
                ),
                children: <Widget>[
                  Column(
                    children: [
                      ...List.generate(
                        _result.length,
                          (index) => Container(
                            decoration: BoxDecoration(
                              //border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: proWidth(25),),
                                    Container(
                                      width: proWidth(100),
                                      height: proWidth(100),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          //정사각형 아니더라도 빈공간 없이 차도록
                                            fit: BoxFit.cover,
                                            image: NetworkImage(_result[index]['headimageUrl']),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(width: proWidth(10),),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_result[index]['brandName']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${_result[index]['productName']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${_result[index]['size']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12
                                          ),
                                        ),
                                        //Widget for selecting date
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: proWidth(20)),
                                  child: Row(
                                    children: [
                                      Expanded(child: Container()),
                                      Row(
                                        children: [
                                          Text(
                                            '${_result[index]['rentalDuration']}일',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            ' 대여',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(width: proWidth(10),),
                                          Text(
                                            '${_result[index]['defaultPrice'] + _result[index]['optionPrice']*(_result[index]['rentalDuration']-3)}원',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: proHeight(10),)
                              ],
                            ),
                          ),
                      )
                    ],
                  )
                ],
              ),
              Container(
                height: 6,
                width: proWidth(500),
                color: Colors.grey.shade200,
              ),
              SizedBox(
                height: proHeight(10),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: proHeight(5), horizontal: proWidth(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                '배송지 정보',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13
                                )
                            ),
                            SizedBox(width: proWidth(8),),
                            Container(
                              height: proHeight(22),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(width: 1, color: Colors.black),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: (){
                                  setState(() {
                                    addAddress(_name, _address, _phoneNumber, _requestText, _detailAddress);
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    '배송지 저장',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: proHeight(22),
                              //width: proWidth(50),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(width: 1, color: Colors.black),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: (){
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context){
                                        return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              centerTitle: true,
                                              title: Text('배송지 목록',style: TextStyle(fontWeight: FontWeight.w800),),
                                            ),
                                            body: Padding(
                                              padding: EdgeInsets.symmetric(vertical: proHeight(20), horizontal: proWidth(20)),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      ...List.generate(
                                                        _addresses.length,
                                                            (index) => Padding(
                                                          padding: EdgeInsets.fromLTRB(0, proHeight(10), 0, proHeight(10)),
                                                          child: GestureDetector(
                                                            onTap: (){
                                                              //배송지를 바꿈
                                                              bottomState((){
                                                                Navigator.pop(context);
                                                                String fulladd = _addresses[index]['address'];
                                                                String mainadd = fulladd.substring(0,fulladd.indexOf("\n"));
                                                                String detailadd = fulladd.substring(fulladd.indexOf("\n")+1);
                                                                setState((){
                                                                  message("배송지가 변경되었습니다!");
                                                                  _name = _addresses[index]['name'];
                                                                  _addressId = _addresses[index]['addressId'];
                                                                  _address = mainadd;
                                                                  _requestText = _addresses[index]['requestText'];
                                                                  _textController.text = _addresses[index]['requestText'];
                                                                  _phoneNumber = _addresses[index]['phoneNumber'];
                                                                  _nameController.text = _name;
                                                                  _numController.text = _phoneNumber;
                                                                  _addressController.text = _address;
                                                                  _detailAddress = detailadd;
                                                                  _detailAddressController.text = _detailAddress;
                                                                });
                                                              });
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                //border: Border.all(color: Colors.grey.shade200),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          '배송지 ${index+1}',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 13
                                                                          )
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            height: proHeight(22),
                                                                            child: OutlinedButton(
                                                                              style: OutlinedButton.styleFrom(
                                                                                side: BorderSide(width: 1, color: Colors.black),
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                                                                backgroundColor: Colors.white,
                                                                              ),
                                                                              onPressed: (){
                                                                                bottomState((){
                                                                                  Navigator.pop(context);
                                                                                  setState(() {
                                                                                    setDefaultAddress(_addresses[index]['addressId']);
                                                                                    setState((){
                                                                                      _name = _addresses[index]['name'];
                                                                                      _addressId = _addresses[index]['addressId'];
                                                                                      _address = _addresses[index]['address'];
                                                                                      _requestText = _addresses[index]['requestText'];
                                                                                      _phoneNumber = _addresses[index]['phoneNumber'];
                                                                                      _textController.text = _addresses[index]['requestText'];
                                                                                      _nameController.text = _name;
                                                                                      _numController.text = _phoneNumber;
                                                                                      _addressController.text = _address;
                                                                                    });
                                                                                  });
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '기본 배송지로 설정',
                                                                                  style: TextStyle(
                                                                                      fontSize: 10,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: proWidth(5),),
                                                                          Container(
                                                                            height: proHeight(22),
                                                                            child: OutlinedButton(
                                                                              style: OutlinedButton.styleFrom(
                                                                                side: BorderSide(width: 1, color: Colors.black),
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                                                                backgroundColor: Colors.white,
                                                                              ),
                                                                              onPressed: (){
                                                                                bottomState((){
                                                                                  Navigator.pop(context);
                                                                                  setState(() {
                                                                                    deleteAddress(_addresses[index]['addressId']);
                                                                                  });
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '삭제',
                                                                                  style: TextStyle(
                                                                                      fontSize: 10,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: proHeight(10)),
                                                                  Row(
                                                                      children : [
                                                                        Expanded(
                                                                          child: Container(
                                                                            height: 1,
                                                                            color: Colors.grey.shade200,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                  ),
                                                                  SizedBox(height: proHeight(10)),
                                                                  Text(
                                                                    _addresses[index]['name'],
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.black
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: proHeight(4)),
                                                                  Text(
                                                                    _addresses[index]['phoneNumber'],
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: proHeight(4)),
                                                                  Text(
                                                                    _addresses[index]['address'],
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: proHeight(10)),
                                                                  Text(
                                                                    _addresses[index]['requestText'],
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: proHeight(15),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    '배송지 목록',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: proHeight(10)),
                  Row(
                      children : [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: proHeight(15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text("이름", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700),),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: Container(
                              height: proHeight(30),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _nameController,
                                onChanged: (val) {
                                  _name = _nameController.text;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: "수령인",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: proHeight(12)
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: proHeight(15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text("번호",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700)),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: Container(
                              height: proHeight(30),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _numController,
                                onChanged: (val) {
                                  _phoneNumber = _numController.text;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: "-없이 입력",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: proHeight(12)
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: proHeight(15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text("주소", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700)),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: GestureDetector(
                              onTap: ()=>{
                                //주소 검색 api
                                _addressAPI()
                              },
                              child: Container(
                                height: proHeight(30),
                                child: TextField(
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _addressController,
                                  onChanged: (val) {
                                    _address = _addressController.text;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: proHeight(15),),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text("상세 주소", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700)),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: Container(
                              height: proHeight(30),
                              child: TextField(
                                enabled: true,
                                keyboardType: TextInputType.text,
                                controller: _detailAddressController,
                                onChanged: (val) {
                                  _detailAddress = _detailAddressController.text;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: "ex) 000아파트 0동 0호",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: proHeight(12)
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: proHeight(15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text('메모', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: Container(
                              height: proHeight(30),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _textController,
                                onChanged: (val) {
                                  _requestText = _textController.text;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: "ex) 부재 시 문앞에 둬주세요.",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: proHeight(15),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: proHeight(10),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: proHeight(5), horizontal: proWidth(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '반납 장소',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13
                            )
                        ),
                        Container(
                          height: proHeight(22),
                          //width: proWidth(50),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1, color: Colors.black),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context){
                                    return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          centerTitle: true,
                                          title: Text('배송지 목록',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),),
                                        ),
                                        body: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: proHeight(20),
                                              horizontal: proWidth(20)),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  ...List.generate(
                                                    _addresses.length,
                                                        (index) =>
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                              0, proHeight(10),
                                                              0, proHeight(10)),
                                                          child: GestureDetector(
                                                            onTap: ()
                                                            {
                                                              Navigator.pop(context);
                                                              //배송지를 바꿈
                                                              String fulladd = _addresses[index]['address'];
                                                              String mainadd = fulladd.substring(0,fulladd.indexOf("\n"));
                                                              String detailadd = fulladd.substring(fulladd.indexOf("\n")+1);
                                                              setState(() {
                                                                _readdress = mainadd;
                                                                _readdressController.text = _readdress;
                                                                _redetailAddress = detailadd;
                                                                _redetailAddressController.text = _redetailAddress;
                                                                message(
                                                                    '반납장소가 변경되었습니다!');
                                                              });
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                //border: Border.all(color: Colors.grey.shade200),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          '배송지 ${index +
                                                                              1}',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize: 13
                                                                          )
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: proWidth(
                                                                                5),),
                                                                          Container(
                                                                            height: proHeight(
                                                                                22),
                                                                            child: OutlinedButton(
                                                                              style: OutlinedButton
                                                                                  .styleFrom(
                                                                                side: BorderSide(
                                                                                    width: 1,
                                                                                    color: Colors
                                                                                        .black),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        proWidth(
                                                                                            20))),
                                                                                backgroundColor: Colors
                                                                                    .white,
                                                                              ),
                                                                              onPressed: () {
                                                                                bottomState((){
                                                                                  Navigator.pop(context);
                                                                                  deleteAddress(
                                                                                      _addresses[index]['addressId']);
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '삭제',
                                                                                  style: TextStyle(
                                                                                      fontSize: 10,
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      color: Colors
                                                                                          .black
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: proHeight(
                                                                          10)),
                                                                  Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            height: 1,
                                                                            color: Colors
                                                                                .grey
                                                                                .shade200,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                  ),
                                                                  SizedBox(
                                                                      height: proHeight(
                                                                          10)),
                                                                  Text(
                                                                    _addresses[index]['name'],
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color: Colors
                                                                            .black
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: proHeight(
                                                                          4)),
                                                                  Text(
                                                                    _addresses[index]['phoneNumber'],
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: proHeight(
                                                                          4)),
                                                                  Text(
                                                                    _addresses[index]['address'],
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: proHeight(
                                                                          10)),
                                                                  Text(
                                                                    _addresses[index]['requestText'],
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: proHeight(
                                                                        15),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                ]
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  }
                              );
                            },
                            child: Center(
                              child: Text(
                                '배송지 목록',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: proHeight(10)),
                  Row(
                      children : [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: proHeight(10)),
                  SizedBox(height: proHeight(6)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text("주소", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700)),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: GestureDetector(
                              onTap: ()=>{
                                //주소 검색 api
                                _addressAPI()
                              },
                              child: Container(
                                height: proHeight(30),
                                child: TextField(
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _readdressController,
                                  onChanged: (val) {
                                    _readdress = _readdressController.text;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: proHeight(15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                    child: Row(
                        children: [
                          Text("상세 주소", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700)),
                          SizedBox(width: proWidth(10)),
                          Expanded(
                            child: Container(
                              height: proHeight(30),
                              child: TextField(
                                enabled: true,
                                keyboardType: TextInputType.text,
                                controller: _redetailAddressController,
                                onChanged: (val) {
                                  _redetailAddress = _redetailAddressController.text;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: "ex) 000아파트 0동 0호",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: proHeight(12)
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: proHeight(15),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //Discount.dart 시작
              Padding(
                padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: proHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '할인 적용',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          height: proHeight(22),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1, color: Colors.black),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context){
                                    return Scaffold(
                                        backgroundColor: Colors.white,
                                        appBar: AppBar(
                                          title: Text('쿠폰함'),
                                        ),
                                        body: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(20)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "사용 가능한 쿠폰 (${_usableCoupon.length})"
                                                ),
                                                SizedBox(height: proHeight(10),),
                                                Column(
                                                  children: <Widget>[
                                                    ...List.generate(
                                                      _usableCoupon.length,
                                                          (index) => Padding(
                                                            padding: EdgeInsets.symmetric(vertical: proHeight(5)),
                                                            child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          StatefulBuilder(
                                                            builder: (context, _setState) => Radio<int>(
                                                              groupValue: _selectedId,
                                                              value: _usableCoupon[index]['couponUserConnectionId'],
                                                              onChanged: (value) {
                                                                _setState(() {
                                                                  _selectedId = value!;
                                                                  _salePrice = _usableCoupon[index]['salePrice'];
                                                                });
                                                                setState((){
                                                                  _selectedId = value!;
                                                                  _salePrice = _usableCoupon[index]['salePrice'];

                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ),
                                                            SizedBox(width: proWidth(10)),
                                                            Expanded(
                                                              child: Container(
                                                                  height: proHeight(80),
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: Colors.black),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(20)),
                                                                    child: Center(
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                              "${_usableCoupon[index]['salePrice']}"
                                                                          ),
                                                                          SizedBox(width: proWidth(20),),
                                                                          Column(
                                                                            children: [
                                                                              Container(width: 1,height: proHeight(35),),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: proWidth(35),),
                                                                          Text(
                                                                              _usableCoupon[index]['couponName']
                                                                          ),
                                                                          SizedBox(width: proWidth(35),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: proHeight(20),),
                                                Text(
                                                    "만료된 쿠폰 (${_expiredCoupon.length})"
                                                ),
                                                SizedBox(height: proHeight(10),),
                                                Column(
                                                  children: <Widget>[
                                                    ...List.generate(
                                                      _expiredCoupon.length,
                                                          (index) => Padding(
                                                        padding: EdgeInsets.symmetric(vertical: proHeight(5)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            StatefulBuilder(
                                                              builder: (context, _setState) => Radio<int>(
                                                                groupValue: _selectedId,
                                                                value: _expiredCoupon[index]['couponUserConnectionId'],
                                                                onChanged: (value) {
                                                                  null;
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: proWidth(10)),
                                                            Expanded(
                                                              child: Container(
                                                                  height: proHeight(80),
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: Colors.black),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(20)),
                                                                    child: Center(
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                              "${_expiredCoupon[index]['salePrice']}"
                                                                          ),
                                                                          SizedBox(width: proWidth(20),),
                                                                          Column(
                                                                            children: [
                                                                              Container(width: 1,height: proHeight(35),),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: proWidth(35),),
                                                                          Text(
                                                                              _expiredCoupon[index]['couponName']
                                                                          ),
                                                                          SizedBox(width: proWidth(35),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    );
                                  }
                              );
                            },
                            child: Center(
                              child: Text(
                                '쿠폰 조회',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: proHeight(10)),
                    Row(
                        children : [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '쿠폰 사용',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              (_salePrice != 0) ?
                              IconButton(onPressed: (){
                                setState((){
                                  _selectedId = 0;
                                  _salePrice = 0;
                                });
                              }, icon: Icon(Icons.dangerous_rounded, size: 15,)) : Text(""),
                            ],
                          ),
                          Text(
                            '(-) $_salePrice원',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: proHeight(15)),
                    Text(
                      '결제 금액',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                        children : [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 상품 금액',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$_totalPrice원',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 배송비',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$_totalDelivery원',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '쿠폰 사용',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '(-) $_salePrice원',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 결제 금액',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            (_totalPrice > _salePrice) ?
                            '${_totalPrice - _salePrice}원'
                            : '0 원',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff15CD5D)
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: proHeight(15)),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: proHeight(15)),
                    Text(
                      '결제 방식',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: proHeight(15)),
                    Row(
                        children : [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: proHeight(10)),
                        Text('무통장 입금',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: proHeight(15)),
                        InkWell(
                          onTap: (){Clipboard.setData(ClipboardData(text: "1005-004-387770 (우리은행)"));},
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '계좌번호: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black
                                    ),
                                  ),
                                  TextSpan(
                                    text: '1005-004-387770 (우리은행)',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff0076AB),
                                    ),
                                    recognizer: TapGestureRecognizer(),
                                  ),
                                ]
                            ),
                          ),
                        ),
                        SizedBox(height: proHeight(5)),
                        Text('예금주: 주식회사 로트렉',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: proHeight(10)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: proWidth(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: proHeight(5),),
                    StatefulBuilder(
                      builder: (context, _setState) =>CheckboxListTile(
                        title: Text("만 14세 이상 결제 동의", style: TextStyle(fontWeight: FontWeight.w600),),
                        tileColor: Colors.white,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.only(left:proWidth(20),),
                        value: _ischecked1,
                        onChanged: (val){
                          setState(() {
                            _ischecked1 = val!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: proHeight(5),),
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
                    SizedBox(height: proHeight(5),),
                    StatefulBuilder(
                      builder: (context, _setState) =>CheckboxListTile(
                        title: Text("주문내용 확인 및 결제 동의", style: TextStyle(fontWeight: FontWeight.w600),),
                        tileColor: Colors.white,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.only(left:proWidth(20),),
                        value: _ischecked2,
                        onChanged: (val){
                          setState(() {
                            _ischecked2 = val!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: proHeight(5),),
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
                    SizedBox(height: proHeight(15)),
                    Center(
                      child: Container(
                        width: proWidth(340),
                        height: proHeight(45),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                            side: BorderSide(width: 1, color: (_ischecked1&&_ischecked2) ? Colors.black : Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            backgroundColor: (_ischecked1&&_ischecked2) ? Colors.black : Colors.grey,
                          ),
                          onPressed: (){
                            if(_ischecked1&&_ischecked2)
                              handlePay();
                            else
                              null;
                          },
                          child: Text(
                            '결제하기',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: proHeight(15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
