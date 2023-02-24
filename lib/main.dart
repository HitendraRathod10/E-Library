import 'package:ebook/addbook/firebaseauth/add_book_auth.dart';
import 'package:ebook/home/provider/home_provider.dart';
import 'package:ebook/home/provider/internet_provider.dart';
import 'package:ebook/login/provider/login_provider.dart';
import 'package:ebook/login/splash_screen.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:ebook/widget/loading_screen.dart';
import 'package:ebook/widget/provider/loading-provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/firebaseauth/phone_sign_in_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     // options: FirebaseOptions(
     //     apiKey: "AIzaSyA4dSktEQqWllJyGd_neNwo9H3K3_z3IRc",
     //     projectId: "ebookapp-82daa",
     //     messagingSenderId: "714531905514",
     //     appId: "1:714531905514:web:809825e63a5b5f3b66dc93"
     // )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<InternetProvider>(create: (_) => InternetProvider()),
        ChangeNotifierProvider<MobileAuthProvider>(create: (_) => MobileAuthProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
        ChangeNotifierProvider<AddBookProvider>(create: (_) => AddBookProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
    ],
      child: MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.whiteColor))),
          appBarTheme: const AppBarTheme(
            color: AppColor.whiteColor,
            elevation: 0.0,
            centerTitle: true,
            titleTextStyle:  TextStyle(
              color: AppColor.appColor,
              fontSize: 16,
            ),
            iconTheme:  IconThemeData(
              color: AppColor.blackColor,
            ),
          ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColor.appColor),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        builder: (context, child) {
          return Loading(child: child!);
        },
      ),
    );
  }
}

