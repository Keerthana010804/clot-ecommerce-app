import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'signin_screen_1.dart';
import 'emailsent_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconContainer(
              icon: Icons.arrow_back_ios_rounded,
              color: AppColors.black,
              size: 16,
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen1(email: '',),));
              },
            ),
            SizedBox(height: 16,),
            buildText(text: fpText, fontWeight: FontWeight.bold,size: 32),
            SizedBox(height: 40,),
            buildContainer(text: enterEmailAddressText),
            SizedBox(height: 20,),
            buildButton(
                text: continueText,
                color: AppColors.primaryColor,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmailSentScreen(),));
                },
            )
          ],
        ),
      ),
    );
  }
}
