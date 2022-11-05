import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';

class OfferScreen extends StatelessWidget {
  static const routeName = "/offerScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              width: Helper.getScreenWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Món Ngon Giảm Giá",
                            style: Helper.getTheme(context).headline5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [Text("Món Ngon Giảm Giá")],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("product")
                              .where("productDiscount", isEqualTo: 1)
                              .snapshots(),
                          builder: ((context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return SizedBox(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => OfferCard(
                                      rate: snapshot.data.docs[index]
                                          ["productRate"],
                                      image: Image.network(
                                        (snapshot.data.docs[index]
                                            ["productImg"]),
                                        fit: BoxFit.cover,
                                      ),
                                      name: snapshot.data.docs[index]
                                          ["productName"]),
                                  itemCount: snapshot.data.docs.length),
                            );
                          })),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              offer: true,
            ),
          )
        ],
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  const OfferCard({
    Key key,
    String name,
    Image image,
    double rate,
  })  : _image = image,
        _name = name,
        _rate = rate,
        super(key: key);

  final String _name;
  final Image _image;
  final double _rate;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 200, width: 500, child: _image),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    _name,
                    style: Helper.getTheme(context)
                        .headline4
                        .copyWith(color: AppColor.primary),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
                  SizedBox(
                    width: 5,
                  ),
                  Text("124 đánh giá"),
                  SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      ".",
                      style: TextStyle(
                          color: AppColor.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(" Món ngon ưu đãi"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
