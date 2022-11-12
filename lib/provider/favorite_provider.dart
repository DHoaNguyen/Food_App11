import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  void favorite({
    @required productId,
    @required productFavorite,
  }) {
    FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userFavorite")
        .doc(productId)
        .set({
      "productId": productId,
      "productFavorite": productFavorite,
    });
  }
}
