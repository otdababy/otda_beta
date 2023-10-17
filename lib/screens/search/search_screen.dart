import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../api/home/category_products_api.dart';
import '../../api/product_page_api.dart';
import '../../api/search/filter_api.dart';
import '../../api/search/keyword_search_api.dart';
import '../../classes/product/product.dart';
import 'components/filter/category.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {


  //SearchBar locals
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  //States that will be kept
  List<dynamic> _result = [];
  List<bool> _brandChecked = List.filled(42,false);
  List<bool> _topChecked = [false,false,false,false,false,false,false,false];
  List<bool> _bottomChecked = [false,false,false,false];
  List<bool> _accChecked = [false,false];
  List<bool> _priceChecked = [false,false,false,false,false,false,false];

  //필터칸에 바로 뜰 박스들
  List<String> _filterChecked = [];

  //필터 카테고리, IDs
  List<String> brand = ['032C','Arcteryx','Affix','Ami', 'Acne Studios','APC','Auralee','All Saints','Balenciaga','Burberry','Comme Des Garcons'
  ,'Dior','Erl','EYTYS','Essentials','Gallery Department','Givenchy','Homme Plisse Issey Miyake','Isabel Marant','Jacquemus','Juun J','Kenzo'
  ,'Lemaire','Loewe','Louis Vuitton','Maison Margiela','Martin Rose','Marni','Moncler', 'Needels','OAMC','Our Legacy','Off-white','Prada',
  'Post Archive Faction','Rick Owens','Saint Laurent','Sandro','Sporty & Rich' , 'Sunnei','Thom Browne','Wooyoungmi','Y/Project'];
  List<int> brandId = [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57];
  List<int> topId = [1,2,3,4,5,6,7,8];
  List<int> bottomId = [9,10,11,12];
  List<int> accId = [13,14];
  List<String> top = ['자켓','스웻셔츠','후드','니트','코트','패딩','셔츠','베스트'];
  List<String> bottom = ['데님 팬츠','트라우저','캐주얼 팬츠','스웻 팬츠'];
  List<String> acc = ['가방','모자'];

  bool _topSelect = false;
  bool _bottomSelect = false;
  bool _accSelect = false;
  List<String> size = ['XS','S','M','L','XL','28','30','32','34','36','OS'];
  List<int> sizeId = [1,2,3,4,5,6,7,8,9,10,11];
  List<bool> _sizeChecked = [false,false,false,false,false,false,false,false,false,false,false,];

  List<String> price = ['10000원 미만','10000원 - 15000원', '15000원 - 20000원','20000원 - 25000원','25000원 - 30000원','30000원 - 35000원','35000원 이상'];
  List<dynamic> prices = [[0,10000],[10000,15000],[15000,20000],[20000,25000],[25000,30000],[30000,35000],[35000,10000000]];


  late TabController _tabController;

  @override
  void initState(){
    _tabController = TabController(
      length: 4,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    loadProduct();
    super.initState();
  }

  void loadProduct() async {
    try{
      var a = await CategoryProductGetApi.getCategoryProduct(59);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      //Get 성공
      if(body['isSuccess']){
        print(result);
        setState((){
          _result = result;
        });
      }
    }
    catch(e) {
      print(e.toString());
    }
  }

  void resetFilter() {
    setState((){
      for(int i=0; i<_brandChecked.length; i++){
        _brandChecked[i] = false;
      }
      for(int i=0; i<_topChecked.length; i++){
        _topChecked[i] = false;
      }
      for(int i=0; i<_accChecked.length; i++){
        _accChecked[i] = false;
      }
      for(int i=0; i<_bottomChecked.length; i++){
        _bottomChecked[i] = false;
      }
      for(int i=0; i<_sizeChecked.length; i++){
        _sizeChecked[i] = false;
      }
      for(int i=0; i<_priceChecked.length; i++){
        _priceChecked[i] = false;
      }
      _filterChecked = [];

      loadProduct();
    });
  }

  void handleProduct(int id) async {
    //GET request
    try{
      var a = await ProductGetApi.getProduct(id);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      //Get 성공
      if(body['isSuccess']){
        if(result['avg_score'] == null){
          result['avg_score'] = 0;
        }
        if(result['reviewCount'] == null){
          result['reviewCount'] = 0;
        }

        //서버에서 product info 따와서 설정 후 화면 로드
        final product = Product(id: result['id'], images: result['images'], productName: result['productName'],
            defaultPrice: result['defaultPrice'], brandName: result['brandName'], availableInstance: result['availableInstance'],
            relatedProducts: result['relatedProducts'], optionPrice: result['optionPrice'], reviewCount: result['reviewCount'],
            reviews: result['reviews'], optionName: result['optionName'],information: result['information'], avg_score: result['avg_score'].toDouble());

        //product를 navigator을 통해 clothing page로 넘긴다
        context.beamToNamed('/clothing_page', data: {'product': product});
      }
    }
    catch(e) {
      print('실패함');
      print(e.toString());
    }
  }

  void search(String searchText) async {
    setState(() {
      _searchController.text;
    });
    //GET request
    try {
      print(searchText);
      var a = await SearchGetApi.getSearch(searchText);
      final body = json.decode(a.body.toString());
      print(body);
      final result = body['result'];
      //save userId and jwt
      if(body['isSuccess']) {
        print("성공함 서치바");
        setState((){
          _result = result;
          print(_result);
          if(result.length == 0){
            //검색된 것이 없으니, 없다는 화면 띄움
          }
        });
      }
      else{
        if(body['code'] == 11401){
          print("query String keyword empty");
          //그냥 원래대로 뉴인 띄움
          loadProduct();
        }
        else if(body['code'] == 4000)
          print("database error");
      }
      setState(() {
        _searchController.text = '';
      });
      if(!mounted) return;
    }
    catch(e){
      print(e);
      print("실패함 서치바");
    }
  }

  void handleFilter() async{

    List<int> cbrandId = [];
    List<int> ccategoryId = [];
    List<int> csizeId = [];
    List<dynamic> cpriceId = [];
    List<int> caccId = [];


    //brand ID 얻어오기
    for(int i=0; i<_brandChecked.length; i++){
      if(_brandChecked[i]){
        cbrandId.add(brandId[i]);
      }
    }
    //top ID 얻어오기
    for(int i=0; i<_topChecked.length; i++){
      if(_topChecked[i]){
        ccategoryId.add(topId[i]);
      }
    }
    //bottom ID 얻어오기
    for(int i=0; i<_bottomChecked.length; i++){
      if(_bottomChecked[i]){
        ccategoryId.add(bottomId[i]);
      }
    }
    //acc ID 얻어오기
    for(int i=0; i<_accChecked.length; i++){
      if(_accChecked[i]){
        ccategoryId.add(accId[i]);
      }
    }
    //size ID 얻어오기
    for(int i=0; i<_sizeChecked.length; i++){
      if(_sizeChecked[i]){
        if(sizeId[i]==3){
          csizeId.add(12);
        }
        if(sizeId[i]==4){
          csizeId.add(13);
        }
        if(sizeId[i]==5){
          csizeId.add(14);
        }
        csizeId.add(sizeId[i]);
      }
    }
    //prices 얻어오기
    for(int i=0; i<_priceChecked.length; i++){
      if(_priceChecked[i]){
        cpriceId.add(prices[i]);
      }
    }
    int startPrice = 0;
    int endPrice = 0;
    if(cpriceId.length !=0){
      startPrice = cpriceId[0][0];
      endPrice = cpriceId[cpriceId.length - 1][1];
    }

    if(cbrandId.length!=0||ccategoryId.length!=0||csizeId.length!=0||cpriceId.length!=0) {
      //GET request
      try {
        var a = await FilterGetApi.getFilter(cbrandId, csizeId, ccategoryId, cpriceId);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        //save userId and jwt
        if (body['isSuccess']) {
          print("성공함 필터검색");
          //여기서 _result를 셋스테이트를 해버린다.
          setState((){
            _result = result;
            _filterChecked = _filterChecked;
            print(_result);
          });
        }
        else {
          if (body['code'] == 11501) {
            print("가격 짝수");
          }
          else if (body['code'] == 11502)
            print("5개중 하나는 있어야댐");
          else if (body['code'] == 4000)
            print("데이터베이스 에러");
        }
        if (!mounted) return;
      }
      catch (e) {
        print(e);
        print("실패함 서치바");
      }
    }
    else{
      loadProduct();
    }
  }

  void selected(){
    setState((){
      _topSelect = false;
      _bottomSelect = false;
      _accSelect = false;
    });

    for(int i=0; i<_topChecked.length; i++){
      if(_topChecked[i]){
        setState((){
          _topSelect = true;
        });
      }
    }
    for(int i=0; i<_bottomChecked.length; i++){
      if(_bottomChecked[i]){
        setState((){
          _bottomSelect = true;
        });
      }
    }
    for(int i=0; i<_accChecked.length; i++){
      if(_accChecked[i]){
        setState((){
          _accSelect = true;
        });
      }
    }
    getSizeFilter();
  }



  void getSizeFilter(){
    print("hi");
    if(_topSelect&&_bottomSelect){
      setState(() {
        size = ['XS','S','M','L','XL','28','30','32','34','36'];
        sizeId = [1,2,3,4,5,6,7,8,9,10];
        _sizeChecked = List.filled(10, false);
      });
    }
    else if(_topSelect&&_accSelect){
      setState(() {
        size = ['XS','S','M','L','XL','OS',];
        sizeId = [1,2,3,4,5,11];
        _sizeChecked = List.filled(6, false);
      });
    }
    else if(_bottomSelect&&_accSelect){
      setState(() {
        size = ['28','30','32','34','36','OS','M','L','XL',];
        sizeId = [6,7,8,9,10,11,12,13,14];
        _sizeChecked = List.filled(9, false);
      });
    }
    else if(_topSelect){
      setState(() {
        size = ['XS','S','M','L','XL',];
        sizeId = [1,2,3,4,5];
        _sizeChecked = List.filled(5, false);
      });
    }
    else if(_bottomSelect){
      setState(() {
        size = ['28','30','32','34','36'];
        sizeId = [6,7,8,9,10,];
        _sizeChecked = List.filled(5, false);
      });
    }
    else if(_accSelect){
      setState(() {
        size = ['OS','M','L','XL'];
        sizeId = [11,12,13,14];
        _sizeChecked = List.filled(4, false);
      });
    }
    else{
      setState(() {
        size = ['XS','S','M','L','XL','28','30','32','34','36','OS'];
        sizeId = [1,2,3,4,5,6,7,8,9,10,11];
        _sizeChecked = List.filled(11, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Column(
              children: [
                SizedBox(height: proHeight(15)),
                Padding(
                  padding: EdgeInsets.all(proWidth(8)),
                  child: Material(
                    child: Form(
                      child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal: proWidth(20)),
                        child: SizedBox(
                          height: proHeight(50),
                          child: TextField(
                            onSubmitted: (value){
                              search(_searchText);
                            },
                            textInputAction: TextInputAction.search,
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true
                            ),
                            controller: _searchController,
                            onChanged: (val) {
                              _searchText = _searchController.text;
                            },
                            style: TextStyle(fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintText: " 브랜드명, 모델명",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: (){
                                    search(_searchText);},
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: proHeight(15)),
                Row(
                    children: [
                      SizedBox(width: proWidth(40)),
                      SizedBox(
                        height: proHeight(40),
                        width: proWidth(60),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            //padding: EdgeInsets.all(5),
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          onPressed: (){
                            showModalBottomSheet(
                                context: context,
                                builder: (context){
                                  return StatefulBuilder( builder: (BuildContext context, StateSetter bottomState)
              {                      return Scaffold(
                                      appBar: AppBar(
                                        actions: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: proWidth(10)),
                                            child: Container(
                                              //height: proHeight(20),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                                    backgroundColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    handleFilter();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('적용', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15)),)
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(proWidth(10)),
                                            child: Container(
                                              //height: proHeight(20),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                                    backgroundColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    bottomState((){
                                                      resetFilter();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text('초기화', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15)),)
                                              ),
                                            ),
                                          ),
                                        ],
                                        centerTitle: true,
                                        bottom: TabBar(
                                          tabs: [
                                            Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Text(
                                                '브랜드',
                                                style: TextStyle(
                                                  fontSize: proWidth(16)
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Text(
                                                '카테고리',
                                                style: TextStyle(
                                                    fontSize: proWidth(16)
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Text(
                                                '사이즈',
                                                style: TextStyle(
                                                    fontSize: proWidth(16)
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Text(
                                                '가격',
                                                style: TextStyle(
                                                    fontSize: proWidth(16)
                                                ),
                                              ),
                                            ),
                                          ],
                                          controller: _tabController,
                                        ),
                                      ),
                                      body: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          //브랜드 로딩
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                for (var i = 0; i < _brandChecked.length; i++)
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(10)),
                                                    child: Row(
                                                      children: [
                                                        StatefulBuilder(
                                                          builder: (context, _setState) => Checkbox(
                                                            value: _brandChecked[i],
                                                            onChanged: (value) {
                                                              _setState(() {
                                                                _brandChecked[i] = value!;
                                                              });
                                                              _setState((){
                                                                if(value!){
                                                                    _filterChecked.add(brand[i]);
                                                                }
                                                                else{
                                                                  _filterChecked.remove(brand[i]);
                                                                  }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: proWidth(10),),
                                                        Text(
                                                          brand[i],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          //카테고리 로딩
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: proWidth(10),vertical: proHeight(10)),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //익스펜더블 위젯 세개 상의 하의 악세서리
                                                  ExpansionTile(
                                                    title: Text(
                                                      '상의',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    children: <Widget>[
                                                      //상의에 대한 하위 카테고리
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          for (var i = 0; i < _topChecked.length; i++)
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(10)),
                                                              child: Row(
                                                                children: [
                                                                  StatefulBuilder(
                                                                    builder: (context, _setState) => Checkbox(
                                                                      value: _topChecked[i],
                                                                      onChanged: (value) {
                                                                        _setState(() {
                                                                          _topChecked[i] = value!;
                                                                        });
                                                                        _setState((){
                                                                          if(value!){
                                                                            _filterChecked.add(top[i]);
                                                                          }
                                                                          else{
                                                                            _filterChecked.remove(top[i]);
                                                                          }});
                                                                        bottomState((){
                                                                          selected();
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: proWidth(10),),
                                                                  Text(
                                                                    top[i],
                                                                    //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  //하의
                                                  ExpansionTile(
                                                    title: Text(
                                                      '하의',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    children: <Widget>[
                                                      //하의 대한 하위 카테고리
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          for (var i = 0; i < bottom.length; i += 1)
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: proWidth(10),vertical: proHeight(10)),
                                                              child: Row(
                                                                children: [
                                                                  StatefulBuilder(
                                                                    builder: (context, _setState) => Checkbox(
                                                                      value: _bottomChecked[i],
                                                                      onChanged: (value) {
                                                                        _setState(() {
                                                                          _bottomChecked[i] = value!;
                                                                        });
                                                                        bottomState((){
                                                                          if(value!){
                                                                            _filterChecked.add(bottom[i]);
                                                                          }
                                                                          else{
                                                                            _filterChecked.remove(bottom[i]);
                                                                          }
                                                                          bottomState((){
                                                                            selected();
                                                                          });
                                                                        });
                                                                      },
                                                                      //tristate: i == 1,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: proWidth(10),),
                                                                  Text(
                                                                    bottom[i],
                                                                    //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  ExpansionTile(
                                                    title: Text(
                                                      '악세사리',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    children: <Widget>[
                                                      //상의에 대한 하위 카테고리
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          for (var i = 0; i < acc.length; i += 1)
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: proWidth(10),vertical: proHeight(10)),
                                                              child: Row(
                                                                children: [
                                                                  StatefulBuilder(
                                                                    builder: (context, _setState) => Checkbox(
                                                                      value: _accChecked[i],
                                                                      onChanged: (value) {
                                                                        _setState(() {
                                                                          _accChecked[i] = value!;
                                                                        });
                                                                        setState((){
                                                                          if(value!){
                                                                            _filterChecked.add(acc[i]);
                                                                          }
                                                                          else{
                                                                            _filterChecked.remove(acc[i]);
                                                                          }
                                                                          bottomState((){
                                                                            selected();
                                                                          });
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: proWidth(10),),
                                                                  Text(
                                                                    acc[i],
                                                                    //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //사이즈 로딩
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                for (var i = 0; i < size.length; i += 1)
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: proWidth(10),vertical: proHeight(10)),
                                                    child: Row(
                                                      children: [
                                                        StatefulBuilder(
                                                          builder: (context, _setState) => Checkbox(
                                                            value: _sizeChecked[i],
                                                            onChanged: (value) {
                                                              _setState(() {
                                                                _sizeChecked[i] = value!;
                                                              });
                                                              _setState((){
                                                                if(value!){
                                                                  _filterChecked.add(size[i]);
                                                                }
                                                                else{
                                                                  _filterChecked.remove(size[i]);
                                                                }
                                                              });
                                                            },
                                                            //tristate: i == 1,
                                                          ),
                                                        ),
                                                        SizedBox(width: proWidth(10),),
                                                        Text(
                                                          size[i],
                                                          //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          //가격 로딩
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                for (var i = 0; i < price.length; i += 1)
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: proWidth(10),vertical: proHeight(10)),
                                                    child: Row(
                                                      children: [
                                                        StatefulBuilder(
                                                          builder: (context, _setState) => Checkbox(
                                                            value: _priceChecked[i],
                                                            onChanged: (value) {
                                                              _setState(() {
                                                                _priceChecked[i] = value!;
                                                              });
                                                              _setState((){
                                                                if(value!){
                                                                  _filterChecked.add(price[i]);
                                                                }
                                                                else{
                                                                      _filterChecked.remove(price[i]);
                                                                }
                                                              });
                                                            },
                                                            //tristate: i == 1,
                                                          ),
                                                        ),
                                                        SizedBox(width: proWidth(10),),
                                                        Text(
                                                          price[i],
                                                          //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );}
                                  );
                                }
                            );
                          },
                          child: SizedBox(
                              height: proHeight(30),
                              width: proWidth(30),
                              child: Image.asset("assets/images/filterimage.png")
                          ),
                        ),
                      ),
                      SizedBox(width: proWidth(10),),
                      Container(width: 1,height: proHeight(40),color: Colors.grey.shade200,),
                      SizedBox(width: proWidth(10),),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                _filterChecked.length,
                                    (index) => Category(
                                      text: _filterChecked[index],
                                      press: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
                SizedBox(height: proHeight(10)),
                Expanded(
                  child: GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: _result.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (0.7),
                        ),
                        itemBuilder: (BuildContext ctx, _index){
                          return GestureDetector(
                            onTap: ()=>{
                              handleProduct(_result[_index]['productId']),
                            },
                            child: Padding(
                              padding: EdgeInsets.all(proWidth(20)),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration:
                                              BoxDecoration(
                                                image: DecorationImage(
                                                  //정사각형 아니더라도 빈공간 없이 차도록
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(_result[_index]['imageUrl'])
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: proHeight(15)),
                                    Padding(
                                      padding: EdgeInsets.only(left: proWidth(5)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _result[_index]['brandName'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize:12
                                            ),
                                            maxLines: 2,
                                          ),
                                          SizedBox(height: proHeight(7)),
                                          Text(
                                            _result[_index]['productName'],
                                            style: TextStyle(color: Colors.black, fontSize: 12),
                                            maxLines: 2,
                                          ),
                                          SizedBox(height: proHeight(7)),
                                          Text(
                                            "Rent ${_result[_index]['defaultPrice']}원~",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 14,
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
    );// snapshot.data  :- get your object which is pass from your downloadData() function
          }
  }