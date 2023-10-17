import 'package:app_v2/classes/product/product_card.dart';
import 'package:flutter/material.dart';

class Product {
  int id;
  String brandName,productName, information;
  List<dynamic> images;
  int defaultPrice;
  int optionPrice;
  String optionName;
  List<dynamic> availableInstance;
  List<dynamic> reviews;
  List<dynamic> relatedProducts;
  int reviewCount;
  double avg_score;

  Product({
    required this.id,
    required this.images,
    required this.productName,
    required this.defaultPrice,
    required this.optionPrice,
    required this.information,
    required this.brandName,
    this.optionName = '',
    this.reviewCount = 0,
    this.avg_score = 0.0,
    required this.availableInstance,
    required this.relatedProducts,
    required this.reviews,
  });
}