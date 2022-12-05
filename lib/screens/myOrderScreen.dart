import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/model/user_model.dart';
import 'package:monkey_app_demo/provider/cart_provider.dart';
import 'package:monkey_app_demo/screens/checkoutScreen.dart';
import 'package:monkey_app_demo/screens/voucherScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  static const routeName = "/myOrderScreen";
  const MyOrderScreen({
    Key key,
    int discount = 0,
    bool isDiscount = false,
  })  : _discount = discount,
        _isDiscount = isDiscount,
        super(key: key);
  final int _discount;
  final bool _isDiscount;

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  var formatter = NumberFormat('##,000');
  UserModel loggedInUser = UserModel();
  User user = FirebaseAuth.instance.currentUser;
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    int subTotal = cartProvider.subTotal();
    int shipFee = 15000;
    int value = subTotal - widget._discount;

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
                                            (DismissDirection direction) async {
                                          setState(() async {
                                            await FirebaseFirestore.instance
                                                .collection("cart")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection("userCart")
                                                .doc(data.productId)
                                                .delete();
                                          });
                                          // await FirebaseFirestore.instance
                                          //     .collection("cart")
                                          //     .doc(FirebaseAuth
                                          //         .instance.currentUser.uid)
                                          //     .collection("userCart")
                                          //     .doc(data.productId)
                                          //     .delete();
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
                              cartProvider.cartList.isEmpty
                                  ? Text("")
                                  : Expanded(
                                      child: Text(
                                        "Mã giảm giá",
                                        style:
                                            Helper.getTheme(context).headline3,
                                      ),
                                    ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(VoucherScreen.routeName);
                                  },
                                  child: cartProvider.cartList.isEmpty
                                      ? Text("")
                                      : Row(
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
                        cartProvider.cartList.isEmpty
                            ? Text("")
                            : Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Tạm tính",
                                      style: Helper.getTheme(context).headline3,
                                    ),
                                  ),
                                  Text(
                                    "${formatter.format(subTotal)}đ",
                                    style: Helper.getTheme(context)
                                        .headline3
                                        .copyWith(
                                          color: AppColor.orange,
                                        ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        cartProvider.cartList.isEmpty
                            ? Text("")
                            : Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Phí giao hàng",
                                      style: Helper.getTheme(context).headline3,
                                    ),
                                  ),
                                  Text(
                                    "${formatter.format(shipFee)}đ",
                                    style: Helper.getTheme(context)
                                        .headline3
                                        .copyWith(
                                          color: AppColor.orange,
                                        ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        cartProvider.cartList.isEmpty
                            ? Text("")
                            : Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Mã giảm giá",
                                      style: Helper.getTheme(context).headline3,
                                    ),
                                  ),
                                  widget._isDiscount
                                      ? Text(
                                          "-${formatter.format(widget._discount)}đ",
                                          style: Helper.getTheme(context)
                                              .headline3
                                              .copyWith(
                                                color: AppColor.orange,
                                              ),
                                        )
                                      : Text(""),
                                ],
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        cartProvider.cartList.isEmpty
                            ? Text("")
                            : Divider(
                                color: AppColor.placeholder.withOpacity(0.25),
                                thickness: 1.5,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        cartProvider.cartList.isEmpty
                            ? Text("")
                            : Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Tổng cộng",
                                      style: Helper.getTheme(context).headline3,
                                    ),
                                  ),
                                  Text(
                                    "${formatter.format(totalPrice)}đ",
                                    style: Helper.getTheme(context)
                                        .headline3
                                        .copyWith(
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
                              ? Text("")
                              : ElevatedButton(
                                  onPressed: () {
                                    if (loggedInUser.address == "" ||
                                        loggedInUser.phone_number == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Thông tin của bạn chưa đầy đủ vui lòng cập nhật")));
                                    } else {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(
                                          discount: widget._discount,
                                          shipFee: shipFee,
                                          subTotal: subTotal,
                                          toTalPrice: totalPrice,
                                        ),
                                      ));
                                    }
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
    var formatter = NumberFormat('##,000');
    return Stack(
      children: [
        Container(
          height: 60,
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
                "${formatter.format(_price * _quantity)}đ",
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
