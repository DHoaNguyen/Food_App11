import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_app_panel/const/colors.dart';
import 'package:food_app_panel/utils/helper.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    Widget messageDialog() {
      return const Text("Bạn có chắc chứ");
    }

    deleCategory(id) async {
      return await FirebaseFirestore.instance
          .collection("category")
          .doc(id)
          .delete();
    }

    showMyDiaLog(String title, message, context, id) async {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(title),
              ),
              content: message,
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Hủy")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        deleCategory(id);
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text("Xóa")),
              ],
            );
          });
    }

    Widget ListCategoryItem(data) {
      return Container(
        margin: const EdgeInsets.all(1),
        width: 5,
        height: 5,
        child: Stack(children: <Widget>[
          Positioned(
            bottom: 0,
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              width: 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data["categoryImg"]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 5,
              child: IconButton(
                  onPressed: () {
                    showMyDiaLog(
                        "Xóa thể loại này", messageDialog(), context, data.id);
                  },
                  icon: const Icon(Icons.close))),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Text(
                "${data["categoryName"]}",
                style: Helper.getTheme(context)
                    .headline3!
                    .copyWith(color: Colors.black),
              )),
        ]),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.size == 0) {
          return const Center(
              child: Text("Không có thể loại, Vui lòng thêm thể loại"));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            dynamic data = snapshot.data!.docs[index];
            return ListCategoryItem(data);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, mainAxisSpacing: 1, crossAxisSpacing: 1),
        );
      },
    );
  }
}
