import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monkey_app_demo/model/cart_model.dart';
import 'package:monkey_app_demo/model/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  List<Product> productByCategoryList = [];
  Future getCartData() async {
    List<CartModel> newCartList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userCart")
        .get();
    querySnapshot.docs.forEach((element) {
      CartModel.fromDocument(element);
      newCartList.add(CartModel.fromDocument(element));
    });
    cartList = newCartList;
    notifyListeners();
  }

  List<CartModel> get getCartList {
    return cartList;
  }

  int subTotal() {
    int subTotal = 0;
    cartList.forEach((element) {
      subTotal += element.productPrice * element.productQuantity;
    });
    return subTotal;
  }

  Future getProductByCategory(String categoryId) async {
    List<Product> newProductByCategoryList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("product").get();
    querySnapshot.docs.forEach((element) {
      if (categoryId == element.get("categoryId")) {
        Product.fromJson(element.data());
        newProductByCategoryList.add(Product.fromJson(element.data()));
      }
    });
    productByCategoryList = newProductByCategoryList;
    notifyListeners();
  }

  List<Product> get getProductByCategoryList {
    return productByCategoryList;
  }
}
