import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monkey_app_demo/screens/forgetPwScreen.dart';
import 'package:monkey_app_demo/screens/homeScreen.dart';
import 'package:monkey_app_demo/screens/introScreen.dart';
import 'package:monkey_app_demo/screens/landingScreen.dart';
import '../const/colors.dart';
import '../screens/forgetPwScreen.dart';
import '../screens/signUpScreen.dart';
import '../utils/helper.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/loginScreen";
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loading = false;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  void signInWithFacebook() async {
    setState(() async {
      loading = true;

      try {
        final result = await FacebookAuth.instance.login();
        final userData = await FacebookAuth.instance.getUserData();
        final authCredential =
            FacebookAuthProvider.credential(result.accessToken.token);
        await FirebaseAuth.instance.signInWithCredential(authCredential);
        await FirebaseFirestore.instance.collection('user').add({
          'email': userData['email'],
          'uid': userData['uid'],
          'imageUrl': userData['picture']['data']['url'],
          'name': userData['name'],
          'address': "",
          'phone_number': "",
        });

        Navigator.of(context).popAndPushNamed(IntroScreen.routeName);
      } on FirebaseAuthException catch (e) {
      } finally {
        setState(() async {
          loading = false;
        });
      }
    });
  }

  void signInWithGoogle() async {
    setState(() {
      loading = true;
    });

    final googleSignIn = GoogleSignIn(scopes: ['email']);
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          loading = false;
        });
        return;
      }
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        'phone_number': "",
        'address': "",
        'uid': FirebaseAuth.instance.currentUser.uid,
        'email': googleSignInAccount.email,
        'imageUrl': googleSignInAccount.photoUrl,
        'name': googleSignInAccount.displayName,
      });
      Navigator.of(context).popAndPushNamed(IntroScreen.routeName);
    } on FirebaseAuthException catch (e) {
      setState(() async {
        loading = false;
      });
    }
  }

  //firebase
  final _auth = FirebaseAuth.instance;
  void signIn(String email, String password) async {
    if (_formkey.currentState.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((uid) => {
                Fluttertoast.showToast(msg: "????ng nh???p th??nh c??ng"),
                Navigator.of(context)
                    .pushReplacementNamed(IntroScreen.routeName),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: "????ng nh???p th???t b???i");
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
        if (value.isEmpty) {
          return ('Vui L??ng nh???p ?????a ch??? email');
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ('Vui l??ng nh???p email h???p l???');
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: 'Nh???p ?????a ch??? Email',
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
          return ('Vui l??ng nh???p m???t kh???u');
        }
        if (!regex.hasMatch(value)) {
          return ("Vui l??ng nh???p ????ng m???t kh???u t???i thi???u 6 k?? t???");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: 'Nh???p m???t kh???u',
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
        child: Text("????ng nh???p"),
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
                  "????ng nh???p",
                  style: Helper.getTheme(context).headline6,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
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
                        loginButton,
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ForgetPwScreen.routeName);
                              },
                              child: Text(
                                "Qu??n m???t kh???u?",
                                style: Helper.getTheme(context).bodyText1,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Ho???c ????ng nh???p v???i",
                              style: Helper.getTheme(context).bodyText1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(
                                      0xFF367FC0,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  signInWithFacebook();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Helper.getAssetName(
                                        "fb.png",
                                        "virtual",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text("????ng nh???p v???i Facebook")
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(
                                      0xFFDD4B39,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  signInWithGoogle();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Helper.getAssetName(
                                        "google.png",
                                        "virtual",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text("????ng nh???p v???i Google")
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                    SignUpScreen.routeName);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("B???n ch??a c?? t??i kho???n?"),
                                  Text(
                                    "T???o t??i kho???n",
                                    style: TextStyle(
                                      color: AppColor.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
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
