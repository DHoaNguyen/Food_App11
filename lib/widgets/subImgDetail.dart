import 'dart:convert';

import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/model/cart_model.dart';
import 'package:monkey_app_demo/provider/favorite_provider.dart';
import 'package:monkey_app_demo/screens/individualItem.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:provider/provider.dart';

class SubImgDetail extends StatefulWidget {
  const SubImgDetail(
      {Key key,
      @required String image,
      @required String name,
      @required int price,
      @required int oldPrice,
      @required double rate,
      @required String productId,
      @required String description})
      : _name = name,
        _oldPrice = oldPrice,
        _rate = rate,
        _price = price,
        _description = description,
        _image = image,
        _productId = productId,
        super(key: key);
  final String _name;
  final int _price;
  final int _oldPrice;
  final double _rate;
  final String _description;
  final String _productId;
  final String _image;

  @override
  State<SubImgDetail> createState() => _SubImgDetailState();
}

class _SubImgDetailState extends State<SubImgDetail> {
  var formatter = NumberFormat('##,000');
  bool isFavorite = false;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

    FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userFavorite")
        .doc(widget._productId)
        .get()
        .then(
          (value) => {
            if (this.mounted)
              {
                if (value.exists)
                  {
                    setState(() {
                      isFavorite = value.get("productFavorite");
                    })
                  }
              }
          },
        );

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyOrderScreen.routeName);
                  },
                  child: Image.asset(
                    Helper.getAssetName("cart_white.png", "virtual"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Helper.getScreenHeight(context) * 0.35,
          ),
          SizedBox(
            height: 800,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    height: 700,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "${widget._name}",
                            style: Helper.getTheme(context).headline5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Image.asset(
                                        Helper.getAssetName(
                                            "star_filled.png", "virtual"),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${widget._rate}",
                                        style: TextStyle(
                                          color: AppColor.orange,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('124 Đánh giá')
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${formatter.format(widget._oldPrice)}đ",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 24),
                                    ),
                                    Text(
                                      "${formatter.format(widget._price)}đ",
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Mô tả",
                            style: Helper.getTheme(context).headline4.copyWith(
                                  fontSize: 16,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(widget._description),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: AppColor.placeholder,
                            thickness: 1.5,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          // child: Text(
                          //   "Lựa chọn",
                          //   style: Helper.getTheme(context)
                          //       .headline4
                          //       .copyWith(
                          //         fontSize: 16,
                          //       ),
                          // ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                "Số lượng",
                                style:
                                    Helper.getTheme(context).headline4.copyWith(
                                          fontSize: 16,
                                        ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(2.0)),
                                      onPressed: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      child: Text("-"),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 35,
                                      width: 55,
                                      decoration: ShapeDecoration(
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                              color: AppColor.orange),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$quantity",
                                            style: TextStyle(
                                              color: AppColor.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(5.0)),
                                      onPressed: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Text("+"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                decoration: ShapeDecoration(
                                  color: AppColor.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Container(
                                    height: 160,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                      left: 50,
                                      right: 40,
                                    ),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          bottomLeft: Radius.circular(40),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: AppColor.placeholder
                                              .withOpacity(0.3),
                                          offset: Offset(0, 5),
                                          blurRadius: 5,
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Tổng cộng",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${formatter.format(widget._price * quantity)}đ",
                                          style: TextStyle(
                                            color: AppColor.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 200,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("cart")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .collection("userCart")
                                                    .doc(widget._productId)
                                                    .set({
                                                  "productId":
                                                      widget._productId,
                                                  "productName": widget._name,
                                                  "productPrice": widget._price,
                                                  "productOldPrice":
                                                      widget._oldPrice,
                                                  "productRate": widget._rate,
                                                  "productQuantity": quantity
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    Helper.getAssetName(
                                                        "add_to_cart.png",
                                                        "virtual"),
                                                  ),
                                                  Text(
                                                    "Thêm vào giỏ hàng",
                                                  )
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shadows: [
                                        BoxShadow(
                                          color: AppColor.placeholder
                                              .withOpacity(0.3),
                                          offset: Offset(0, 5),
                                          blurRadius: 5,
                                        ),
                                      ],
                                      shape: CircleBorder(),
                                    ),
                                    child: Image.asset(
                                      Helper.getAssetName(
                                          "cart_filled.png", "virtual"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ClipShadow(
                      clipper: CustomTriangle(),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.placeholder,
                          offset: Offset(0, 5),
                          blurRadius: 5,
                        ),
                      ],
                      child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.white,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                  if (isFavorite == true) {
                                    favoriteProvider.favorite(
                                      productId: widget._productId,
                                      productFavorite: true,
                                    );
                                  } else if (isFavorite == false) {
                                    FirebaseFirestore.instance
                                        .collection("favorite")
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .collection("userFavorite")
                                        .doc(widget._productId)
                                        .delete();
                                  }
                                });
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite_outlined
                                    : Icons.favorite_border_outlined,
                                color: AppColor.orange,
                              ))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
