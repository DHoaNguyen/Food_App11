import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/model/cart_model.dart';
import 'package:monkey_app_demo/model/product_model.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';

import '../widgets/customNavBar.dart';
import 'individualItem.dart';

class MyFavoriteScreen extends StatefulWidget {
  static const routeName = "/myFavoriteScreen";
  const MyFavoriteScreen({Key key}) : super(key: key);
  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  List<Product> listProduct = [];

  Future<void> getProduct() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userFavorite")
        .get();

    querySnapshot.docs.forEach((element) async {
      DocumentReference<Map<String, dynamic>> favoriteItem =
          FirebaseFirestore.instance.collection("product").doc(element.id);
      await favoriteItem.get().then((snapshot) {
        listProduct.add(Product.fromJson(snapshot.data()));
      });
    });
  }

  Widget buildRecentItem() {
    return Container(
        padding: const EdgeInsets.only(
          left: 20,
        ),
        child: SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              return RecentItemCard(
                  ontap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return IndividualItem(
                          productId: listProduct[index].productId,
                          description: listProduct[index].productDescription,
                          image: Image.network(
                            (listProduct[index].productImg),
                            fit: BoxFit.cover,
                          ),
                          rate: listProduct[index].productRate,
                          name: listProduct[index].productName,
                          price: listProduct[index].productPrice,
                          oldPrice: listProduct[index].productOldPrice,
                        );
                      },
                    ));
                  },
                  rate: listProduct[index].productRate,
                  image: Image.network(
                    (listProduct[index].productImg),
                    fit: BoxFit.cover,
                  ),
                  name: listProduct[index].productName);
            },
          ),
        ));
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadingAction();
  }

  loadingAction() async {
    await getProduct();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    // return Scaffold(
    //   body: isLoading
    //       ? Center(child: CircularProgressIndicator())
    //       : buildRecentItem(),
    // );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Danh sách ưu thích",
                              style: Helper.getTheme(context).headline5,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(MyOrderScreen.routeName);
                        },
                        child: Image.asset(
                          Helper.getAssetName("cart_white.png", "virtual"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    listProduct.isEmpty
                        ? Center(
                            child: Text(
                            "Chưa thêm sản phẩm ưu thích",
                            style: Helper.getTheme(context)
                                .headline4
                                .copyWith(color: AppColor.primary),
                          ))
                        : buildRecentItem(),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: CustomNavBar(
                favorite: true,
              )),
        ],
      ),
    );
  }
}

class RecentItemCard extends StatelessWidget {
  const RecentItemCard(
      {Key key,
      @required String name,
      @required Image image,
      @required Function ontap,
      @required double rate})
      : _name = name,
        _image = image,
        _rate = rate,
        _ontap = ontap,
        super(key: key);

  final String _name;
  final Image _image;
  final double _rate;
  final Function _ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _ontap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              child: _image,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: Helper.getTheme(context)
                        .headline4
                        .copyWith(color: AppColor.primary),
                  ),
                  Row(
                    children: [
                      Text("Món ngon "),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          ".",
                          style: TextStyle(
                            color: AppColor.orange,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Ưu đãi"),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Helper.getAssetName("star_filled.png", "virtual"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${_rate}",
                        style: TextStyle(
                          color: AppColor.orange,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('124 Đánh giá')
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
