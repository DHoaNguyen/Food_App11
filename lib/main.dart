import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app_panel/const/colors.dart';
import 'package:food_app_panel/provider/cart_provider.dart';
import 'package:food_app_panel/screen/addCategory.dart';
import 'package:food_app_panel/screen/addProduct.dart';
import 'package:food_app_panel/screen/homeScreen.dart';
import 'package:food_app_panel/screen/loginScreen.dart';
import 'package:food_app_panel/screen/orderHistory.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCI1nlxd0RZRLfwze0vlfZyku2z-j42Vys",
          appId: "1:380281081470:android:cae30c5484f6359521522f",
          messagingSenderId: "380281081470",
          projectId: "food-app-3d1f6",
          storageBucket: "gs://food-app-3d1f6.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Arial",
        //    primarySwatch: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              AppColor.orange,
            ),
            shape: MaterialStateProperty.all(
              const StadiumBorder(),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              AppColor.orange,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headline3: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headline5: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
          headline6: TextStyle(
            color: AppColor.primary,
            fontSize: 25,
          ),
          bodyText2: TextStyle(
            color: AppColor.secondary,
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        // '/': (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        AddCategoryScreen.routeName: (context) => const AddCategoryScreen(),
        OrderHistoryScreen.routeName: (context) => OrderHistoryScreen(),
        AddProductScreen.routeName: (context) => const AddProductScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
 

// flutter run -d chrome --web-renderer html
