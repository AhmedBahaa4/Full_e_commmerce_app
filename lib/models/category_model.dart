// import 'dart:ui';

// import 'package:e_commerc_app/utils/app_color.dart';

// class CategoryModel {
//   final String id;
//   final String name;
//   final int productsCount;
//   final Color bgColor;
//   final Color textcolor;
//   final String? imageUrl;

//   CategoryModel({
//     required this.id,
//     required this.name,
//     required this.productsCount,
//     this.bgColor = AppColors.primary,
//     this.textcolor = AppColors.black,
//     this.imageUrl,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'productsCount': productsCount,
//       'bgColor': bgColor.value,
//       'textcolor': textcolor.value,
//       'imageUrl': imageUrl,
//     };
//   }

// ignore_for_file: deprecated_member_use

//   factory CategoryModel.fromMap(Map<String, dynamic> map) {
//     return CategoryModel(
//       id: map['id'],
//       name: map['name'],
//       productsCount: map['productsCount'],
//       bgColor: Color(map['bgColor']),
//       textcolor: Color(map['textcolor']),
//       imageUrl: map['imageUrl'],
//     );
//   }
// }
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textcolor;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textcolor = AppColors.white,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'productsCount': productsCount});

    result.addAll({'bgColor': bgColor.toARGB32()});

    result.addAll({'textColor': textcolor.toARGB32()});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      productsCount: map['productsCount']?.toInt() ?? 0,
      bgColor: Color((map['bgColor'] ?? AppColors.primary.toARGB32()) as int),
      textcolor: Color(
        (map['textcolor'] ?? map['textColor'] ?? AppColors.white.toARGB32())
            as int,
      ),
    );
  }
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '1',
    name: 'New Arrivals',
    productsCount: 208,
    bgColor: AppColors.grey,
    textcolor: AppColors.black,
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
    bgColor: AppColors.green,
    textcolor: AppColors.white,
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
    bgColor: AppColors.black,
    textcolor: AppColors.white,
  ),
  CategoryModel(
    id: '4',
    name: 'Shoes',
    productsCount: 230,
    bgColor: AppColors.grey,
    textcolor: AppColors.black,
  ),
  CategoryModel(
    id: '5',
    name: 'Electronics',
    productsCount: 101,
    bgColor: AppColors.blue,
    textcolor: AppColors.white,
  ),
];
