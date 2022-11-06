import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monkey_app_demo/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
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
}
