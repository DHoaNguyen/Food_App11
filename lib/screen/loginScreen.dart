import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app_panel/screen/homeScreen.dart';
import '../const/colors.dart';
import '../utils/helper.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/loginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loading = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //firebase
  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Đăng nhập thành công"),
                Navigator.of(context).pushNamed(HomeScreen.routeName),
              })
          .catchError((e) async {
        Fluttertoast.showToast(msg: "Đăng nhập thất bại");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Vui Lòng nhập địa chỉ email');
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ('Vui lòng nhập email hợp lệ');
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        hintText: 'Nhập địa chỉ Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ('Vui lòng nhập mật khẩu');
        }
        if (!regex.hasMatch(value)) {
          return ("Vui lòng nhập đúng mật khẩu tối thiểu 6 kí tự");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        hintText: 'Nhập mật khẩu',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final loginButton = SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text("Đăng nhập"),
      ),
    );

    return Scaffold(
        body: SizedBox(
      height: Helper.getScreenHeight(context),
      width: Helper.getScreenWidth(context),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Đăng nhập",
                  style: Helper.getTheme(context).headline6,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        emailField,
                        const SizedBox(
                          height: 30,
                        ),
                        passwordField,
                        const SizedBox(
                          height: 30,
                        ),
                        loginButton,
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
