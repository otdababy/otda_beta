import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FilterGetApi {
  static Future<http.Response> getFilter(List<int>brandId,List<int>sizeId,List<int>categoryId,List<dynamic>cpriceId) async {

    String query = "";
    //loop to create brand query string
    for(int i=0; i<brandId.length; i++){
      if(query != "")
        query += '&brand=${brandId[i]}';
      else
        query += 'brand=${brandId[i]}';
    }
    //loop to create size query string
    for(int i=0; i<sizeId.length; i++){
      if(query != "")
        query += '&size=${sizeId[i]}';
      else
        query += 'size=${sizeId[i]}';
    }
    //loop to create category query string
    for(int i=0; i<categoryId.length; i++){
      if(query != "")
        query += '&category=${categoryId[i]}';
      else
        query += 'category=${categoryId[i]}';
    }
    //create price query string
    for(int i=0; i<cpriceId.length; i++){
      if(query != ""){
        query += '&price=${cpriceId[i][0]}';
        query += '&price=${cpriceId[i][1]}';
      }
      else{
        query += 'price=${cpriceId[i][0]}';
        query += '&price=${cpriceId[i][1]}';
      }
    }

    print(query);

    //delete last letter of query if ending with an &
    //String queryString = query.substring(0, query.length - 1);

    final url = Uri.parse(
        'https://otdabeta.shop/app/filter?${query}');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}
