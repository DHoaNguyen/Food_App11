import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_panel/model/cart_model.dart';

class GetCategory {
  Future<List<CategoryModel>> getCategory() async {
    List<CategoryModel> list = [];

    final ref = FirebaseFirestore.instance.collection("category");
// final snapshot = await ref.child('users/$userId').get();
    QuerySnapshot abc = await ref.get();

    return [];
  }
}
