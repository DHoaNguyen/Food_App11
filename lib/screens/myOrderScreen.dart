import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/provider/cart_provider.dart';
import 'package:monkey_app_demo/screens/checkoutScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  static const routeName = "/myOrderScreen";
  const MyOrderScreen({
    Key key,
  }) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    int subTotal = cartProvider.subTotal();
    int shipFee = 15;
    int discount = 0;
    int value = subTotal - discount;

    int totalPrice = value += shipFee;

    if (cartProvider.cartList.isEmpty) {
      setState(() {
        shipFee = totalPrice = 0;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Giỏ hàng",
                          style: Helper.getTheme(context).headline5,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    color: AppColor.placeholderBg,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: AppColor.placeholderBg,
                            child: cartProvider.cartList.isEmpty
                                ? Center(
                                    child: Text(
                                    "Giỏ hàng hiện tại trống",
                                    style: Helper.getTheme(context)
                                        .headline4
                                        .copyWith(color: AppColor.primary),
                                  ))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var data =
                                          cartProvider.getCartList[index];
                                      dynamic itemId = cartProvider
                                          .getCartList[index].productId;
                                      return Dismissible(
                                        key: Key(itemId),
                                        onDismissed:
                                            (DismissDirection direction) {
                                          setState(() async {
                                            await FirebaseFirestore.instance
                                                .collection("cart")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection("userCart")
                                                .doc(data.productId)
                                                .delete();
                                          });
                                        },
                                        background:
                                            Container(color: AppColor.orange),
                                        secondaryBackground:
                                            Container(color: Colors.green),
                                        child: BurgerCard(
                                          productId: data.productId,
                                          name: data.productName,
                                          price: data.productPrice,
                                          quantity: data.productQuantity,
                                        ),
                                      );
                                    },
                                    itemCount: cartProvider.getCartList.length,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColor.placeholder.withOpacity(0.25),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Mã giảm giá",
                                  style: Helper.getTheme(context).headline3,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: AppColor.orange,
                                      ),
                                      Text(
                                        "Thêm mã",
                                        style: TextStyle(
                                          color: AppColor.orange,
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Tạm tính",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            Text(
                              "${subTotal}K",
                              style:
                                  Helper.getTheme(context).headline3.copyWith(
                                        color: AppColor.orange,
                                      ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Phí giao hàng",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            Text(
                              "${shipFee}K",
                              style:
                                  Helper.getTheme(context).headline3.copyWith(
                                        color: AppColor.orange,
                                      ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: AppColor.placeholder.withOpacity(0.25),
                          thickness: 1.5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Tổng cộng",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            Text(
                              "${totalPrice}K",
                              style:
                                  Helper.getTheme(context).headline3.copyWith(
                                        color: AppColor.orange,
                                        fontSize: 22,
                                      ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: cartProvider.cartList.isEmpty
                              ? ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Bạn không thể đặt hàng khi giỏ hàng trống")));
                                  },
                                  child: Text("Đặt hàng"),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CheckoutScreen(
                                        discount: discount,
                                        shipFee: shipFee,
                                        subTotal: subTotal,
                                        totalPrice: totalPrice,
                                      ),
                                    ));
                                  },
                                  child: Text("Đặt hàng"),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BurgerCard extends StatelessWidget {
  const BurgerCard({
    Key key,
    String name,
    dynamic price,
    int quantity,
    String productId,
    bool isLast = false,
  })  : _name = name,
        _price = price,
        _isLast = isLast,
        _productId = productId,
        _quantity = quantity,
        super(key: key);

  final String _name;
  final dynamic _price;
  final bool _isLast;
  final int _quantity;
  final String _productId;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: _isLast
              ? BorderSide.none
              : BorderSide(
                  color: AppColor.placeholder.withOpacity(0.25),
                ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$_name x $_quantity ",
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            "${_price * _quantity}K",
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    );
  }
}
