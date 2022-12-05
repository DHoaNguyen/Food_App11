import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/model/order_model.dart';
import 'package:monkey_app_demo/model/user_model.dart';
import 'package:monkey_app_demo/provider/cart_provider.dart';
import 'package:monkey_app_demo/screens/homeScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = "/checkoutScreen";
  const CheckoutScreen({
    Key key,
    @required this.discount,
    @required this.shipFee,
    @required this.subTotal,
    @required this.toTalPrice,
  }) : super(key: key);

  final int subTotal;
  final int toTalPrice;
  final int shipFee;
  final int discount;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var formatter = NumberFormat('##,000');
  UserModel loggedInUser = UserModel();
  User user = FirebaseAuth.instance.currentUser;
  void deleteUserCart() async {
    var collection = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userCart");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  bool isLoading = true;
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
    Future.delayed(Duration(seconds: 1), () {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              "Thanh toán",
                              style: Helper.getTheme(context).headline5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Địa chỉ"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Helper.getScreenWidth(context) * 0.8,
                              child: Text(
                                "${loggedInUser.address} ",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Số điện thoại"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Helper.getScreenWidth(context) * 0.8,
                              child: Text(
                                "${loggedInUser.phone_number} ",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 10,
                        width: double.infinity,
                        color: AppColor.placeholderBg,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Phương thức thanh toán"),
                            Row(
                              children: [
                                Icon(Icons.add, color: AppColor.orange),
                                Text(
                                  "Thêm thẻ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.orange,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      PaymentCard(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Thanh toán bằng tiền mặt"),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                shape: CircleBorder(
                                  side: BorderSide(color: AppColor.orange),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 10,
                        width: double.infinity,
                        color: AppColor.placeholderBg,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Tạm tính",
                                    style: Helper.getTheme(context).headline3,
                                  ),
                                ),
                                Text(
                                  "${formatter.format(widget.subTotal)}đ",
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Phí giao hàng",
                                    style: Helper.getTheme(context).headline3,
                                  ),
                                ),
                                Text(
                                  "${formatter.format(widget.shipFee)}đ",
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Mã giảm giá",
                                    style: Helper.getTheme(context).headline3,
                                  ),
                                ),
                                Text(
                                  "-${formatter.format(widget.discount)}đ",
                                  style: Helper.getTheme(context)
                                      .headline3
                                      .copyWith(
                                        color: AppColor.orange,
                                      ),
                                )
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: AppColor.placeholder.withOpacity(0.25),
                              thickness: 2,
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
                                  "${formatter.format(widget.toTalPrice)}đ",
                                  style: Helper.getTheme(context)
                                      .headline3
                                      .copyWith(
                                        color: AppColor.orange,
                                        fontSize: 22,
                                      ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                        width: double.infinity,
                        color: AppColor.placeholderBg,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Order order = Order(
                                userId: FirebaseAuth.instance.currentUser.uid,
                                dayCreate: DateTime.now(),
                                orderId: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                statusOrder: "Đã đặt hàng",
                                totalPrice: widget.toTalPrice.toDouble(),
                              );
                              await FirebaseFirestore.instance
                                  .collection("order")
                                  .add(order.toJson());
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: Helper.getScreenHeight(context) *
                                          0.68,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            Helper.getAssetName(
                                              "vector4.png",
                                              "virtual",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Thank You",
                                            style: TextStyle(
                                              color: AppColor.primary,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Chúng tôi rất cảm ơn vì bạn đã đặt hàng",
                                            style: Helper.getTheme(context)
                                                .headline4
                                                .copyWith(
                                                    color: AppColor.primary),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                                "Đơn hàng của bạn sẽ được chúng tôi xử lý"),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            // child: SizedBox(
                                            //   height: 50,
                                            //   width: double.infinity,
                                            //   child: ElevatedButton(
                                            //     onPressed: () {
                                            //       Navigator.of(context)
                                            //           .pushReplacementNamed(
                                            //               OrderHistoryScreen
                                            //                   .routeName);
                                            //     },
                                            //     child: Text("Kiểm tra đơn hàng"),
                                            //   ),
                                            // ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: SizedBox(
                                              height: 50,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          HomeScreen.routeName);
                                                },
                                                child: Text("Trở về trang chủ"),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                              deleteUserCart();
                            },
                            child: Text("Đặt hàng"),
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

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    Key key,
    Widget widget,
  })  : _widget = widget,
        super(key: key);

  final Widget _widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 30,
            right: 20,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: AppColor.placeholder.withOpacity(0.25),
              ),
            ),
            color: AppColor.placeholderBg,
          ),
          child: _widget),
    );
  }
}
