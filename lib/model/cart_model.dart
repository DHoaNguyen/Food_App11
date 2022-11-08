import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartModel {
  final String productId;
  final String productName;
  final int productQuantity;
  final dynamic productPrice;
  CartModel(
      {@required this.productId,
      @required this.productName,
      @required this.productPrice,
      @required this.productQuantity});
  factory CartModel.fromDocument(QueryDocumentSnapshot doc) {
    return CartModel(
      productId: doc["productId"],
      productName: doc["productName"],
      productPrice: doc["productPrice"],
      productQuantity: doc["productQuantity"],
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> doc) {
    return CartModel(
      productId: doc["productId"],
      productName: doc["productName"],
      productPrice: doc["productPrice"],
      productQuantity: doc["productQuantity"],
    );
  }
}
