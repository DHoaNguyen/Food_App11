import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String categoryId;
  final String categoryName;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
  });
  factory CategoryModel.fromDocument(QueryDocumentSnapshot doc) {
    return CategoryModel(
      categoryId: doc["categoryId"],
      categoryName: doc["categoryName"],
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> doc) {
    return CategoryModel(
      categoryId: doc["categoryId"],
      categoryName: doc["categoryName"],
    );
  }
}
