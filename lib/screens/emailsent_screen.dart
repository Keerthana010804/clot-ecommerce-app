import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/asset_constants.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'signin_screen.dart';

class EmailSentScreen extends StatefulWidget {
  const EmailSentScreen({super.key});

  @override
  State<EmailSentScreen> createState() => _EmailSentScreenState();
}

class _EmailSentScreenState extends State<EmailSentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetConstants.emailSentImage,
              height: 100,
              width: 100,
            ),
            SizedBox(height: 24),
            Text(
              sentAnEmailText,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.black,fontSize: 24,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen(),));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    returnToLoginText,
                    style: TextStyle(color: AppColors.white,),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
