import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/model/user_model.dart';
import 'package:monkey_app_demo/screens/landingScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profileScreen";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;
  User user = FirebaseAuth.instance.currentUser;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LandingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: Helper.getScreenHeight(context),
                width: Helper.getScreenWidth(context),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEdit = true;
                                  });
                                },
                                icon: Icon(Icons.mode_edit_outline))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ClipOval(
                          child: Stack(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                child: Image.asset(
                                  Helper.getAssetName(
                                    "user.jpg",
                                    "real",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 20,
                                  width: 80,
                                  color: Colors.black.withOpacity(0.3),
                                  child: Image.asset(Helper.getAssetName(
                                      "camera.png", "virtual")),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Xin chào Hòa",
                          style: Helper.getTheme(context).headline4.copyWith(
                                color: AppColor.primary,
                              ),
                        ),
                        TextButton(onPressed: () {}, child: Text("Đăng xuất")),
                        CustomFormImput(
                          label: "Name",
                          value: "Hòa",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomFormImput(
                          label: "Email",
                          value: "111@email.com",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomFormImput(
                          label: "Số điện thoại",
                          value: "01696115627",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomFormImput(
                          label: "Địa chỉ",
                          value: "180/28/ Nguyễn Hữu Cảnh",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: isEdit
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isEdit = false;
                                    });
                                  },
                                  child: Text("Lưu"),
                                )
                              : Text(""),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              profile: true,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFormImput extends StatelessWidget {
  const CustomFormImput({
    Key key,
    String label,
    String value,
    bool isPassword = false,
  })  : _label = label,
        _value = value,
        _isPassword = isPassword,
        super(key: key);

  final String _label;
  final String _value;
  final bool _isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        initialValue: _value,
        obscureText: _isPassword,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
