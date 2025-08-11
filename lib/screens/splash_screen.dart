import 'dart:async';
import 'package:e_commerce/screens/signin_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/asset_constants.dart';
import 'package:e_commerce/utils/shared_preference.dart';
import 'package:flutter/material.dart';

import 'home/home_page_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
   super.initState();
   Timer(Duration(seconds: 3), (){
     // Navigator.pushReplacementNamed(context, '/signin' /*'/homepage'*/);
     bool isLogin = SharedPrefs.getLoginStatus();
     if(isLogin){
       // Navigate to home page or details screen
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => HomePageScreen()),
       );
     }else{
       // Navigate to home page or details screen
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => SignInScreen()),
       );
     }
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(
          AssetConstants.splashImage,
          height: 175,
          width: 80,
        ),
      ),
    );
  }
}
