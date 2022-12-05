import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screens/individualItem.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'myOrderScreen.dart';

class RecentScreen extends StatefulWidget {
  static const routeName = "/recentScreen";

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  String query = "";
  var result;
  searchFunction(query, searchList) {
    result = searchList.where((element) {
      return element["productName"].toUpperCase().contains(query) ||
          element["productName"].toLowerCase().contains(query) ||
          element["productName"].toUpperCase().contains(query) &&
              element["productName"].toLowerCase().contains(query);
    }).toList();
    return result;
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
                  itemBuilder: (context, index) {
                    var varData = searchFunction(query, snapshot.data.docs);
                    var data = varData[index];
                    return RecentItemCard(
                        ontap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return IndividualItem(
                                productId: data["productId"],
                                description: data["productDescription"],
                                image: Image.network(
                                  (data["productImg"]),
                                  fit: BoxFit.cover,
                                ),
                                rate: data["productRate"],
                                name: data["productName"],
                                price: data["productPrice"],
                                oldPrice: data["productOldPrice"],
                              );
                            },
                          ));
                        },
                        rate: snapshot.data.docs[index]["productRate"],
                        image: Image.network(
                          (snapshot.data.docs[index]["productImg"]),
                          fit: BoxFit.cover,
                        ),
                        name: snapshot.data.docs[index]["productName"]);
                  },
                  itemCount: snapshot.data.docs.length),
            );
          })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColor.primary,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "Gần đây",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: AppColor.placeholderBg,
                      ),
                      child: TextField(
                        onChanged: ((value) {
                          setState(() {
                            query = value;
                          });
                        }),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Image.asset(
                            Helper.getAssetName("search_filled.png", "virtual"),
                          ),
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(
                            color: AppColor.placeholder,
                            fontSize: 18,
                          ),
                          contentPadding: const EdgeInsets.only(
                            top: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  query == ""
                      ? Column(
                          children: [
                            buildRecentItem(),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("product")
                                  .snapshots(),
                              builder: ((context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                var varData =
                                    searchFunction(query, snapshot.data.docs);
                                return SizedBox(
                                  child: result.isEmpty
                                      ? Center(
                                          child: Text(
                                          "Không tìm thấy sản phẩm",
                                          style: Helper.getTheme(context)
                                              .headline4
                                              .copyWith(
                                                  color: AppColor.primary),
                                        ))
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = varData[index];
                                            return RecentItemCard(
                                                ontap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) {
                                                      return IndividualItem(
                                                        productId:
                                                            data["productId"],
                                                        description: data[
                                                            "productDescription"],
                                                        image: Image.network(
                                                          (data["productImg"]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        rate:
                                                            data["productRate"],
                                                        name:
                                                            data["productName"],
                                                        price: data[
                                                            "productPrice"],
                                                        oldPrice: data[
                                                            "productOldPrice"],
                                                      );
                                                    },
                                                  ));
                                                },
                                                rate: data["productRate"],
                                                image: Image.network(
                                                  (data["productImg"]),
                                                  fit: BoxFit.cover,
                                                ),
                                                name: data["productName"]);
                                          },
                                          itemCount: result.length),
                                );
                              })),
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
