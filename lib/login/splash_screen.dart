import 'dart:async';
import 'package:ebook/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_preference_key.dart';
import '../utils/app_utils.dart';
import '../widget/bottom_navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  bool isUserLogin=false;
  String? email;

  getPreferenceData()async{
    isUserLogin= await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefLogin)??false;
    email=await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefPhone)?? "";
    setState(() {});
    Timer(
        const Duration(seconds: 3), (){
          if(isUserLogin){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>  const BottomNavBarScreen()));
          } else{
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>  const LoginScreen()));
          }
      });
  }


  @override
  void initState() {
    super.initState();
    getPreferenceData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImage.appLogo,height: 130,width: 130,fit: BoxFit.fill),
            const SizedBox(height: 10),
            const Text('Ebook',style: TextStyle(color: AppColor.appColor,fontSize: 20))
          ],
        ),
      ),
    );
  }
}