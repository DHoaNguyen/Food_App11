import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/model/user_model.dart';
import 'package:monkey_app_demo/screens/categoryScreen.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/screens/recentScreen.dart';
import 'package:provider/provider.dart';

import '../const/colors.dart';
import '../utils/helper.dart';
import '../widgets/customNavBar.dart';
import '../screens/individualItem.dart';
import '../widgets/searchBar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();
  User user = FirebaseAuth.instance.currentUser;
  String query = " ";

  Widget buidCategory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("category").snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              height: 110,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CategoryCard(
                      ontap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                              id: snapshot.data.docs[index].id,
                              collection: snapshot.data.docs[index]
                                  ["categoryName"]),
                        ));
                      },
                      image: Image.network(
                        (snapshot.data.docs[index]["categoryImg"]),
                        fit: BoxFit.cover,
                      ),
                      name: snapshot.data.docs[index]["categoryName"]),
                  itemCount: snapshot.data.docs.length),
            );
          })),
    );
  }

  Widget buildRecentItem() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("product").snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => RecentItemCard(
                      ontap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IndividualItem(
                            productId: snapshot.data.docs[index]["productId"],
                            description: snapshot.data.docs[index]
                                ["productDescription"],
                            image: Image.network(
                              (snapshot.data.docs[index]["productImg"]),
                              fit: BoxFit.cover,
                            ),
                            rate: snapshot.data.docs[index]["productRate"],
                            name: snapshot.data.docs[index]["productName"],
                            price: snapshot.data.docs[index]["productPrice"],
                            oldPrice: snapshot.data.docs[index]
                                ["productOldPrice"],
                          ),
                        ));
                      },
                      rate: snapshot.data.docs[index]["productRate"],
                      image: Image.network(
                        (snapshot.data.docs[index]["productImg"]),
                        fit: BoxFit.cover,
                      ),
                      name: snapshot.data.docs[index]["productName"]),
                  itemCount: 6),
            );
          })),
    );
  }

  Widget buildPopular() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: SizedBox(
        height: 120,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("product")
                .where("productRate", isGreaterThan: 4)
                .orderBy("productRate", descending: true)
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => MostPopularCard(
                      ontap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IndividualItem(
                            productId: snapshot.data.docs[index]["productId"],
                            description: snapshot.data.docs[index]
                                ["productDescription"],
                            image: Image.network(
                              (snapshot.data.docs[index]["productImg"]),
                              fit: BoxFit.cover,
                            ),
                            rate: snapshot.data.docs[index]["productRate"],
                            name: snapshot.data.docs[index]["productName"],
                            price: snapshot.data.docs[index]["productPrice"],
                            oldPrice: snapshot.data.docs[index]
                                ["productOldPrice"],
                          ),
                        ));
                      },
                      rate: snapshot.data.docs[index]["productRate"],
                      image: Image.network(
                        (snapshot.data.docs[index]["productImg"]),
                        fit: BoxFit.cover,
                      ),
                      name: snapshot.data.docs[index]["productName"]),
                  itemCount: snapshot.data.docs.length);
            })),
      ),
    );
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Xin Chào!",
                                style: Helper.getTheme(context).headline5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text("Giao đến"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Helper.getScreenWidth(context) * 0.8,
                                  child: Text(
                                    "${loggedInUser.address} ",
                                    style: Helper.getTheme(context).headline4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buidCategory(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Gần Đây",
                                style: Helper.getTheme(context).headline5,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(RecentScreen.routeName);
                                },
                                child: Text("Tất cả"),
                              ),
                            ],
                          ),
                        ),
                        buildRecentItem(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phổ biến",
                                style: Helper.getTheme(context).headline4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildPopular(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: CustomNavBar(
                      home: true,
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
                        "$_rate",
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

class MostPopularCard extends StatelessWidget {
  const MostPopularCard(
      {Key key,
      @required String name,
      @required Image image,
      @required double rate,
      @required Function ontap})
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 250,
              height: 100,
              child: _image,
            ),
          ),
          SizedBox(
            height: 10,
            width: 280,
          ),
          Text(
            _name,
            style: Helper.getTheme(context)
                .headline4
                .copyWith(color: AppColor.primary),
          ),
          Row(
            children: [
              Text("Món ngon"),
              SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
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
              Image.asset(
                Helper.getAssetName("star_filled.png", "virtual"),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$_rate",
                style: TextStyle(
                  color: AppColor.orange,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.image,
    @required this.name,
    @required this.ontap,
  }) : super(key: key);

  final String name;
  final Image image;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 70,
              height: 70,
              child: image,
            ),
          ),
          SizedBox(
            width: 100,
            height: 10,
          ),
          Text(
            name,
            style: Helper.getTheme(context)
                .headline4
                .copyWith(color: AppColor.primary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
