import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const routeName = "/orderHistoryScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios_rounded),
                      ),
                      Expanded(
                        child: Text(
                          "Lịch sử đặt hàng",
                          style: Helper.getTheme(context).headline5,
                        ),
                      ),
                      Image.asset(
                        Helper.getAssetName("cart.png", "virtual"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("order")
                        .where("userId",
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => OrderHistory(
                                statusOrder: snapshot.data.docs[index]
                                    ["statusOrder"],
                                color: AppColor.placeholderBg,
                                time: DateFormat('kk:mm dd-MM-yyyy').format(
                                    DateTime.parse(snapshot.data.docs[index]
                                        ["dayCreate"])),
                                title: snapshot.data.docs[index]["orderId"],
                                totalPrice: snapshot.data.docs[index]
                                    ["totalPrice"]),
                            itemCount: snapshot.data.docs.length),
                      );
                    })),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderHistory extends StatelessWidget {
  const OrderHistory({
    Key key,
    String time,
    String title,
    String statusOrder,
    double totalPrice,
    Color color = Colors.white,
  })  : _time = time,
        _title = title,
        _statusOrder = statusOrder,
        _color = color,
        _totalPrice = totalPrice,
        super(key: key);

  final String _time;
  final String _title;
  final String _statusOrder;
  final Color _color;
  final double _totalPrice;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('##,000');
    return Container(
      height: 115,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _color,
        border: Border(
          bottom: BorderSide(
            color: AppColor.placeholder,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.orange,
            radius: 5,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mã đơn hàng $_title",
                  style: Helper.getTheme(context)
                      .headline3
                      .copyWith(color: AppColor.primary),
                ),
                SizedBox(height: 5),
                Text(_statusOrder),
                SizedBox(height: 5),
                Text("Tổng tiền :${formatter.format(_totalPrice)}đ"),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _time,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
