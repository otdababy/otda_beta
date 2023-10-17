import 'dart:convert';

import 'package:app_v2/api/search/keyword_search_api.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';

class SearchCategoryPage extends StatefulWidget {
  const SearchCategoryPage({Key? key,
  //required this.categories
  }) : super(key: key);
  //final List<dynamic> categories;

  @override
  _SearchCategoryPageState createState() => _SearchCategoryPageState();
}

class _SearchCategoryPageState extends State<SearchCategoryPage> with TickerProviderStateMixin{
  _SearchCategoryPageState({
    Key? key,
    //required this.categories
  });


  List<dynamic> categories = [];

  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children:[
        Column(
          children: [
            Container(
              child: TabBar(
                tabs: [
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '브랜드',
                    ),
                  ),
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '카테고리',
                    ),
                  ),
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '사이즈',
                    ),
                  ),
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '가격',
                    ),
                  ),
                ],
                indicator: BoxDecoration(
                  gradient: LinearGradient(  //배경 그라데이션 적용
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blueAccent,
                      Colors.pinkAccent,
                    ],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
              ),
            ),
            TabBarView(
              controller: _tabController,
              children: [
                Container(
                  color: Colors.green[200],
                  alignment: Alignment.center,
                  child: Text(
                    'Tab2 View',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  color: Colors.green[200],
                  alignment: Alignment.center,
                  child: Text(
                    'Tab2 View',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]
    );
  }
}