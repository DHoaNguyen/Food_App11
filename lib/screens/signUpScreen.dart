import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monkey_app_demo/model/user_model.dart';
import 'package:monkey_app_demo/screens/homeScreen.dart';
import '../const/colors.dart';
import '../screens/loginScreen.dart';
import '../utils/helper.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  const SignUpScreen({Key key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController phone_numberController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmController = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  void signUp(String email, String password) async {
    if (_formkey.currentState.validate()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => {postDetailToFireStone()})
          .catchError((e) {
        Fluttertoast.showToast(msg: "Đăng kí thất bại");
      });
    }
  }

  postDetailToFireStone() async {
    //goi firestone
    //goi usermodel
    //gui value

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.address = addressController.text;
    userModel.phone_number = phone_numberController.text;

    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Tạo tài khoản thành công");

    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value.isEmpty) {
          return ('Vui lòng nhập tên');
        }
        if (!regex.hasMatch(value)) {
          return ("Tên phải tối thiểu 3 kí tự");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: 'Nhập tên của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return ('Vui Lòng nhập địa chỉ email');
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value.isEmpty) {
          return ('Vui lòng nhập mật khẩu');
        }
        if (!regex.hasMatch(value)) {
          return ("Vui lòng nhập đúng mật khẩu tối thiểu 6 kí tự");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: 'Nhập mật khẩu',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmController,
      obscureText: true,
      validator: (value) {
        if (confirmController.text != passwordController.text) {
          return "Mật khẩu không trùng hợp";
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: 'Xác nhận mật khẩu',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final signupButton = SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: Text("Đăng ký"),
      ),
    );
    return Scaffold(
        body: Container(
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
                  "Đăng ký",
                  style: Helper.getTheme(context).headline6,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        nameField,
                        SizedBox(
                          height: 30,
                        ),
                        emailField,
                        SizedBox(
                          height: 30,
                        ),
                        passwordField,
                        SizedBox(
                          height: 30,
                        ),
                        confirmpasswordField,
                        SizedBox(
                          height: 30,
                        ),
                        signupButton,
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bạn đã có tài khoản?"),
                              Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  color: AppColor.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
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
