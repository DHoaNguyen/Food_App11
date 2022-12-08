import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:food_app_panel/const/colors.dart';
import 'package:food_app_panel/screen/homeScreen.dart';
import 'package:food_app_panel/utils/helper.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const routeName = "/orderHistoryScreen";

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: '/homeScreen',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Quản lý Danh mục sản phẩm',
            route: '/categoryScreen',
            icon: Icons.file_copy,
          ),
          AdminMenuItem(
            title: 'Quản lý sản phẩm',
            icon: Icons.production_quantity_limits_sharp,
            route: '/productScreen',
            children: [],
          ),
          AdminMenuItem(
            title: 'Đơn đặt hàng',
            icon: Icons.castle_outlined,
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          if (item.route != null) {
            Navigator.of(context).pushNamed(item.route!);
          }
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("order")
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => OrderHistory(
                                statusOrder: snapshot.data!.docs[index]
                                    ["statusOrder"],
                                color: AppColor.placeholderBg,
                                time: DateFormat('kk:mm dd-MM-yyyy').format(
                                    DateTime.parse(snapshot.data!.docs[index]
                                        ["dayCreate"])),
                                title: snapshot.data!.docs[index]["orderId"],
                                totalPrice: snapshot.data!.docs[index]
                                    ["totalPrice"]),
                            itemCount: snapshot.data!.docs.length),
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
    Key? key,
    required String time,
    required String title,
    required String statusOrder,
    required double totalPrice,
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
      height: 100,
      width: 140,
      decoration: BoxDecoration(
        color: _color,
        border: const Border(
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
          const CircleAvatar(
            backgroundColor: AppColor.orange,
            radius: 5,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mã đơn hàng#$_title",
                  style: Helper.getTheme(context)
                      .headline3!
                      .copyWith(color: AppColor.primary),
                ),
                const SizedBox(height: 5),
                // ignore: unnecessary_string_interpolations
                Text("$_statusOrder"),
                const SizedBox(height: 5),
                Text("Tổng tiền :${formatter.format(_totalPrice)}đ"),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _time,
                style: const TextStyle(
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
