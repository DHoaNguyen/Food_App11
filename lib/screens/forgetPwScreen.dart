import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import '../utils/helper.dart';

class ForgetPwScreen extends StatefulWidget {
  static const routeName = "/restpwScreen";

  @override
  State<ForgetPwScreen> createState() => _ForgetPwScreenState();
}

class _ForgetPwScreenState extends State<ForgetPwScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();

  Future resetPassWord() async {
    try {
      if (_formkey.currentState.validate()) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text)
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Đã gửi link lấy lại mật khẩu vui lòng kiểm tra email"))));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Helper.getScreenWidth(context),
        height: Helper.getScreenWidth(context),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Text(
                    "Quên mật khẩu",
                    style: Helper.getTheme(context).headline6,
                  ),
                  Spacer(),
                  Text(
                    "Vui lòng nhập địa chỉ email để tạo mới lại mật khẩu",
                    textAlign: TextAlign.center,
                  ),
                  Spacer(flex: 2),
                  TextFormField(
                    autofocus: true,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ('Vui lòng nhập địa chỉ email');
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ('Vui lòng nhập email hợp lệ');
                      }
                      return null;
                    },
                    onSaved: (value) {
                      emailController.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Nhập địa chỉ Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        resetPassWord();
                      },
                      child: Text("Gửi"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
