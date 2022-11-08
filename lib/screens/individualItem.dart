import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/imgDetail.dart';
import 'package:monkey_app_demo/widgets/subImgDetail.dart';

class IndividualItem extends StatelessWidget {
  static const routeName = "/individualScreen";
  const IndividualItem(
      {Key key,
      @required this.image,
      @required this.name,
      @required this.price,
      @required this.oldPrice,
      @required this.rate,
      @required this.productId,
      @required this.description})
      : super(key: key);

  final Image image;
  final String name;
  final int price;
  final int oldPrice;
  final double rate;
  final String description;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ImgDetail(image: image),
                    SubImgDetail(
                        image: image.toString(),
                        productId: productId,
                        description: description,
                        name: name,
                        price: price,
                        oldPrice: oldPrice,
                        rate: rate),
                  ],
                ),
                // SizedBox(
                //   height: 10,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset controlpoint = Offset(size.width * 0, size.height * 0.5);
    Offset endpoint = Offset(size.width * 0.2, size.height * 0.85);
    Offset controlpoint2 = Offset(size.width * 0.33, size.height);
    Offset endpoint2 = Offset(size.width * 0.6, size.height * 0.9);
    Offset controlpoint3 = Offset(size.width * 1.4, size.height * 0.5);
    Offset endpoint3 = Offset(size.width * 0.6, size.height * 0.1);
    Offset controlpoint4 = Offset(size.width * 0.33, size.height * 0);
    Offset endpoint4 = Offset(size.width * 0.2, size.height * 0.15);

    Path path = new Path()
      ..moveTo(size.width * 0.2, size.height * 0.15)
      ..quadraticBezierTo(
        controlpoint.dx,
        controlpoint.dy,
        endpoint.dx,
        endpoint.dy,
      )
      ..quadraticBezierTo(
        controlpoint2.dx,
        controlpoint2.dy,
        endpoint2.dx,
        endpoint2.dy,
      )
      ..quadraticBezierTo(
        controlpoint3.dx,
        controlpoint3.dy,
        endpoint3.dx,
        endpoint3.dy,
      )
      ..quadraticBezierTo(
        controlpoint4.dx,
        controlpoint4.dy,
        endpoint4.dx,
        endpoint4.dy,
      );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

// child: Image.asset(
//   Helper.getAssetName("pizza3.jpg", "real"),
//   fit: BoxFit.cover,
// ),

