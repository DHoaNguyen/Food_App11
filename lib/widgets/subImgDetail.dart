import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screens/individualItem.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';

class SubImgDetail extends StatefulWidget {
  const SubImgDetail(
      {Key key,
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
        _productId = productId,
        super(key: key);
  final String _name;
  final int _price;
  final int _oldPrice;
  final double _rate;
  final String _description;
  final String _productId;

  @override
  State<SubImgDetail> createState() => _SubImgDetailState();
}

class _SubImgDetailState extends State<SubImgDetail> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
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
                                      "${widget._oldPrice}K",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    Text(
                                      "${widget._price}K",
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20),
                        //   child: Container(
                        //     height: 50,
                        //     width: double.infinity,
                        //     padding: const EdgeInsets.only(
                        //         left: 30, right: 10),
                        //     decoration: ShapeDecoration(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.circular(5),
                        //       ),
                        //       color: AppColor.placeholderBg,
                        //     ),
                        //     child: DropdownButtonHideUnderline(
                        //       child: DropdownButton(
                        //         hint: Row(
                        //           children: [
                        //             Text(
                        //                 "-Select the size of portion-"),
                        //           ],
                        //         ),
                        //         value: "default",
                        //         onChanged: (_) {},
                        //         items: [
                        //           DropdownMenuItem(
                        //             child: Text(
                        //                 "-Select the size of portion-"),
                        //             value: "default",
                        //           ),
                        //         ],
                        //         icon: Image.asset(
                        //           Helper.getAssetName(
                        //             "dropdown.png",
                        //             "virtual",
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20),
                        //   child: Container(
                        //     height: 50,
                        //     width: double.infinity,
                        //     padding: const EdgeInsets.only(
                        //         left: 30, right: 10),
                        //     decoration: ShapeDecoration(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.circular(5),
                        //       ),
                        //       color: AppColor.placeholderBg,
                        //     ),
                        //     child: DropdownButtonHideUnderline(
                        //       child: DropdownButton(
                        //         hint: Row(
                        //           children: [
                        //             Text(
                        //                 "-Select the ingredients-"),
                        //           ],
                        //         ),
                        //         value: "default",
                        //         onChanged: (_) {},
                        //         items: [
                        //           DropdownMenuItem(
                        //             child: Text(
                        //                 "-Select the ingredients-"),
                        //             value: "default",
                        //           ),
                        //         ],
                        //         icon: Image.asset(
                        //           Helper.getAssetName(
                        //             "dropdown.png",
                        //             "virtual",
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                          "${widget._price * quantity}K",
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
                                                // Navigator.of(context).pushNamed(
                                                //     MyOrderScreen.routeName);
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
                        child: Image.asset(
                          Helper.getAssetName(
                            "fav.png",
                            "virtual",
                          ),
                        ),
                      ),
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
