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
  UserModel loggedInUser = UserModel();
  bool isEdit = false;
  User user = FirebaseAuth.instance.currentUser;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController phoneNumberController =
      new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LandingScreen.routeName);
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  void updateProfile() {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      "name": nameController.text,
      "phone_number": phoneNumberController.text,
      "address": addressController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: SafeArea(
                      child: Container(
                        height: Helper.getScreenHeight(context),
                        width: Helper.getScreenWidth(context),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                          child: Image.asset(
                                              Helper.getAssetName(
                                                  "camera.png", "virtual")),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Xin chào ${loggedInUser.name} ",
                                  style: Helper.getTheme(context)
                                      .headline4
                                      .copyWith(
                                        color: AppColor.primary,
                                      ),
                                ),
                                isEdit
                                    ? Text("")
                                    : TextButton(
                                        onPressed: () {
                                          logout(context);
                                        },
                                        child: Text("Đăng xuất")),
                                isEdit
                                    ? Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: TextFormField(
                                          controller: nameController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Vui lòng nhập tên";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            nameController.text = value;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Tên",
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                            "${loggedInUser.name}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 15,
                                ),
                                isEdit
                                    ? SizedBox(
                                        height: 1,
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                            "${loggedInUser.email}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 15,
                                ),
                                isEdit
                                    ? Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: phoneNumberController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return ('Vui Lòng nhập số điện thoại');
                                            }
                                            if (!RegExp("^[0-9]")
                                                .hasMatch(value)) {
                                              return ('Vui lòng nhập đúng số điện thoại');
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            phoneNumberController.text = value;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Số điện thoại",
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                            "${loggedInUser.phone_number}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 15,
                                ),
                                isEdit
                                    ? Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: TextFormField(
                                          controller: addressController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Vui lòng nhập địa chỉ";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            addressController.text = value;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Địa chỉ",
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: AppColor.placeholderBg,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                            "${loggedInUser.address}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: isEdit
                                      ? ElevatedButton(
                                          onPressed: () {
                                            if (_formkey.currentState
                                                .validate()) {
                                              setState(() {
                                                isEdit = false;
                                                print(_formkey.currentState);
                                                updateProfile();
                                              });
                                            }
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
    String handler,
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
