import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screens/homeScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';

class IntroScreen extends StatefulWidget {
  static const routeName = "/introScreen";

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  var _controller;
  int count;
  final List<Map<String, String>> _pages = [
    {
      "image": "vector1.png",
      "title": "Đa dạng món ăn",
      "desc":
          "Món ăn vô cùng đa dạng và phong phú giúp bạn có thể dễ dàng lựa chọn"
    },
    {
      "image": "vector2.png",
      "title": "Giao hàng nhanh chóng",
      "desc": "Đơn hàng của bạn sẽ được xử lý và giao đến tận tay của bạn"
    },
    {
      "image": "vector3.png",
      "title": "Kiểm tra đơn hàng",
      "desc": "Giúp bạn có thể kiểm tra những đơn hàng đã đặt"
    },
  ];

  @override
  void initState() {
    _controller = new PageController();
    count = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Helper.getScreenWidth(context),
        height: Helper.getScreenHeight(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Spacer(),
                Container(
                  height: 370,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (value) {
                      setState(() {
                        count = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(Helper.getAssetName(
                          _pages[index]["image"], "virtual"));
                    },
                    itemCount: _pages.length,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          count == 0 ? AppColor.orange : AppColor.placeholder,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          count == 1 ? AppColor.orange : AppColor.placeholder,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          count == 2 ? AppColor.orange : AppColor.placeholder,
                    )
                  ],
                ),
                Spacer(),
                Text(
                  _pages[count]["title"],
                  style: Helper.getTheme(context).headline6,
                ),
                Spacer(),
                Text(
                  _pages[count]["desc"],
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(HomeScreen.routeName);
                      },
                      child: Text("Next")),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
