import 'dart:convert';

import 'package:app_v2/api/search/keyword_search_api.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchText = '';

  //controllers
  final TextEditingController _searchController = TextEditingController();

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
        context.beamToNamed('/search', data:{'products' : result});
      }
      else{
        if(body['code'] == 11401){
          print("query String keyword empty");
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(proWidth(8)),
      child: Material(
        child: Form(
          child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: proWidth(20)),
            child: SizedBox(
              height: proHeight(50),
              child: TextField(
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
                decoration: InputDecoration(
                  hintText: " 브랜드명, 모델명",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 17
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: (){
                      search(_searchText);},
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
    );
  }
}