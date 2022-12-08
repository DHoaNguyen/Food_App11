import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:food_app_panel/const/colors.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Widget analyticWidget(
      String? title,
      int value,
    ) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.placeholder),
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  // ignore: unnecessary_brace_in_string_interps
                  " ${title} ",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: 135,
                      child: Center(
                        child: Text(
                          "$value",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.show_chart_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget analyticWidget1(
      String? title,
      int value,
    ) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.placeholder),
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  // ignore: unnecessary_brace_in_string_interps
                  " ${title} ",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: 135,
                      child: Center(
                        child: Text(
                          "$value",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.show_chart_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget analyticWidget2(
      String? title,
      int value,
    ) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.placeholder),
            borderRadius: BorderRadius.circular(15),
            color: Colors.deepOrange,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  // ignore: unnecessary_brace_in_string_interps
                  " ${title} ",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: 135,
                      child: Center(
                        child: Text(
                          "$value",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.show_chart_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget analyticWidget3(
      String? title,
      int value,
    ) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.placeholder),
            borderRadius: BorderRadius.circular(15),
            color: Colors.greenAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  // ignore: unnecessary_brace_in_string_interps
                  " ${title} ",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: 135,
                      child: Center(
                        child: Text(
                          "$value",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.show_chart_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AdminScaffold(
        backgroundColor: Colors.white24,
        // appBar: AppBar(
        //   title: const Text('Menu Admin'),
        // ),
        sideBar: SideBar(
          items: const [
            AdminMenuItem(
              title: 'Dashboard',
              //      route: '/',
              icon: Icons.dashboard,
            ),
            AdminMenuItem(
              title: 'Quản lý Thể loại',
              route: '/categoryScreen',
              icon: Icons.file_copy,
            ),
            AdminMenuItem(
              title: 'Quản lý sản phẩm',
              icon: Icons.production_quantity_limits_sharp,
              route: '/productScreen',
            ),
            AdminMenuItem(
              title: 'Đơn đặt hàng',
              icon: Icons.castle_outlined,
              route: '/orderHistoryScreen',
            ),
          ],
          selectedRoute: '/',
          onSelected: (item) {
            if (item.route != null) {
              Navigator.of(context).pushNamed(item.route!);
            }
          },
          // header: Container(
          //   height: 50,
          //   width: double.infinity,
          //   color: const Color(0xff444444),
          //   child: const Center(
          //     child: Text(
          //       'header',
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // footer: Container(
          //   height: 50,
          //   width: double.infinity,
          //   color: const Color(0xff444444),
          //   child: const Center(
          //     child: Text(
          //       'footer',
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return analyticWidget(
                          "Tổng user ", snapshot.data!.size.toInt());
                    })),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("category")
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return analyticWidget1(
                          "Tổng thể loại", snapshot.data!.size.toInt());
                    })),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("product")
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return analyticWidget2(
                          "Tổng sản phẩm", snapshot.data!.size.toInt());
                    })),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("order")
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return analyticWidget3(
                          "Tổng đơn hàng", snapshot.data!.size.toInt());
                    })),
              ],
            )
          ],
        ));
  }
}
