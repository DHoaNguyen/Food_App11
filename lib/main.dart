// ignore_for_file: missing_required_param
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/provider/cart_provider.dart';
import 'package:monkey_app_demo/provider/favorite_provider.dart';
import 'package:monkey_app_demo/screens/changeAddressScreen.dart';
import 'package:monkey_app_demo/screens/myFavoriteScreen.dart';
import 'package:monkey_app_demo/screens/orderHistory.dart';
import 'package:monkey_app_demo/screens/voucherScreen.dart';
import 'package:provider/provider.dart';
import './screens/spashScreen.dart';
import './screens/landingScreen.dart';
import './screens/loginScreen.dart';
import 'screens/signUpScreen.dart';
import './screens/forgetPwScreen.dart';
import './screens/newPwScreen.dart';
import './screens/introScreen.dart';
import './screens/homeScreen.dart';
import './screens/menuScreen.dart';
import './screens/moreScreen.dart';
import './screens/offerScreen.dart';
import './screens/profileScreen.dart';
import './screens/dessertScreen.dart';
import './screens/individualItem.dart';
import './screens/paymentScreen.dart';
import './screens/notificationScreen.dart';
import './screens/aboutScreen.dart';
import './screens/inboxScreen.dart';
import './screens/myOrderScreen.dart';
import './screens/checkoutScreen.dart';
import './const/colors.dart';
import './screens/recentScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Arial",
          primarySwatch: Colors.red,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AppColor.orange,
              ),
              shape: MaterialStateProperty.all(
                StadiumBorder(),
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
          textTheme: TextTheme(
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
        home: SplashScreen(),
        routes: {
          LandingScreen.routeName: (context) => LandingScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          ForgetPwScreen.routeName: (context) => ForgetPwScreen(),
          NewPwScreen.routeName: (context) => NewPwScreen(),
          IntroScreen.routeName: (context) => IntroScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          MenuScreen.routeName: (context) => MenuScreen(),
          OfferScreen.routeName: (context) => OfferScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          MoreScreen.routeName: (context) => MoreScreen(),
          DessertScreen.routeName: (context) => DessertScreen(),
          IndividualItem.routeName: (context) => IndividualItem(),
          PaymentScreen.routeName: (context) => PaymentScreen(),
          NotificationScreen.routeName: (context) => NotificationScreen(),
          AboutScreen.routeName: (context) => AboutScreen(),
          InboxScreen.routeName: (context) => InboxScreen(),
          MyOrderScreen.routeName: (context) => MyOrderScreen(),
          CheckoutScreen.routeName: (context) => CheckoutScreen(),
          ChangeAddressScreen.routeName: (context) => ChangeAddressScreen(),
          RecentScreen.routeName: (context) => RecentScreen(),
          MyFavoriteScreen.routeName: (context) => MyFavoriteScreen(),
          OrderHistoryScreen.routeName: (context) => OrderHistoryScreen(),
          VoucherScreen.routeName: (context) => VoucherScreen(),
        },
      ),
    );
  }
}
