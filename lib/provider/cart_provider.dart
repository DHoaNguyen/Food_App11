import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monkey_app_demo/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  CartModel cartModel;
  Future getCartData() async {
    List<CartModel> newCartList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userCart")
        .get();
    querySnapshot.docs.forEach((element) {
      CartModel.fromDocument(element);
      newCartList.add(cartModel);
    });
    cartList = newCartList;
    print(cartList.length);
    notifyListeners();
  }

  List<CartModel> get getCartList {
    return cartList;
  }
}
