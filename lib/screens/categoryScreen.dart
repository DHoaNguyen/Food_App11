import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/provider/cart_provider.dart';
import 'package:monkey_app_demo/screens/individualItem.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/searchBar.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/categoryScreen";
  final String id;
  final String collection;

  const CategoryScreen({
    Key key,
    @required this.id,
    @required this.collection,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getProductByCategory(widget.id);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                SearchBar(
                  title: "Tìm kiếm",
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data =
                              cartProvider.getProductByCategoryList[index];
                          return MostPopularCard(
                            rate: data.productRate,
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => IndividualItem(
                                  productId: data.productId,
                                  description: data.productDescription,
                                  image: Image.network(data.productImg),
                                  rate: data.productRate,
                                  name: data.productName,
                                  price: data.productPrice,
                                  oldPrice: data.productOldPrice,
                                ),
                              ));
                            },
                            image: Image.network(cartProvider
                                .getProductByCategoryList[index].productImg),
                            name: cartProvider
                                .getProductByCategoryList[index].productName,
                          );
                        },
                        itemCount: cartProvider.productByCategoryList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

// SearchBar(
//   title: "Search Food",
// ),

// GestureDetector(
//   onTap: () {
//     Navigator.of(context).pop();
//   },
//   child: Icon(
//     Icons.arrow_back_ios_rounded,
//     color: AppColor.primary,
//   ),
// ),

// FutureBuilder(
//   future: FirebaseFirestore.instance
//       .collection("category")
//       .doc(id)
//       .collection(collection)
//       .get(),
//   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     return GridView.builder(
//       itemBuilder: (context, index) {
//         return Container();
//       },
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2),
//     );
//   },
// )

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
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 200,
              height: 90,
              child: _image,
            ),
          ),
          SizedBox(
            height: 10,
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
                width: 5,
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
