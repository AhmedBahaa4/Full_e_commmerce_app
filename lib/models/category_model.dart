import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textcolor;
  final String? imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textcolor = AppColors.white,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'productsCount': productsCount,
      'bgColor': bgColor.toARGB32(),
      'textColor': textcolor.toARGB32(),
      'imageUrl': imageUrl,
    };
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
      imageUrl: map['imageUrl'] as String?,
    );
  }
}
