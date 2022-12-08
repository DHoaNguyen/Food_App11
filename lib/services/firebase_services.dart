import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  CollectionReference categories =
      FirebaseFirestore.instance.collection("category");
  CollectionReference users = FirebaseFirestore.instance.collection("category");

  CollectionReference products =
      FirebaseFirestore.instance.collection("product");

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> SaveCategory(CollectionReference reference,
      Map<String, dynamic> data, String docName) {
    return reference.doc(docName).set(data);
  }
}
