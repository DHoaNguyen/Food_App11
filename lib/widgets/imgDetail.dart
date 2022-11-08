import 'package:flutter/material.dart';
import 'package:monkey_app_demo/utils/helper.dart';

class ImgDetail extends StatelessWidget {
  const ImgDetail({
    Key key,
    @required Image image,
  })  : _image = image,
        super(key: key);
  final Image _image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Helper.getScreenHeight(context) * 0.5,
          width: Helper.getScreenWidth(context),
          child: _image,
        ),
        Container(
          height: Helper.getScreenHeight(context) * 0.5,
          width: Helper.getScreenWidth(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.4],
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
