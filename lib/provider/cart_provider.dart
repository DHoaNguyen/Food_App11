import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_app_panel/model/cart_model.dart';

class CategoryProvider {
  List<CategoryModel> cartList = [];
  Future getCartData() async {
    List<CategoryModel> newCartList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("category").get();
    querySnapshot.docs.forEach((element) {
      CategoryModel.fromDocument(element);
      newCartList.add(CategoryModel.fromDocument(element));
    });
    cartList = newCartList;
  }

  List<CategoryModel> get getCartList {
    return cartList;
  }
}
