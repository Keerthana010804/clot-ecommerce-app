import 'package:e_commerce/screens/home/home_page_screen.dart';
import 'package:e_commerce/screens/signin_screen.dart';
import 'package:e_commerce/utils/color_constants.dart' show AppColors;
import 'package:e_commerce/utils/shared_preference.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_widgets.dart';
import 'forgot_password.dart';

class SignInScreen1 extends StatefulWidget {
  final String email; // get email from previous screen

  const SignInScreen1({super.key, required this.email});

  @override
  State<SignInScreen1> createState() => _SignInScreen1State();
}

class _SignInScreen1State extends State<SignInScreen1> {
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  void _signIn() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter your password")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Authenticate with Firebase
      UserCredential? user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: password,
      );
      if(user.user != null){
        SharedPrefs.saveLoginStatus(true);
      }
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


    } on FirebaseAuthException catch (e) {
      String errorMsg = "An error occurred";
      if (e.code == 'wrong-password') {
        errorMsg = "Wrong password";
      } else if (e.code == 'user-not-found') {
        errorMsg = "User not found";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(text: signInText, fontWeight: FontWeight.bold, size: 32),
              SizedBox(height: 40),
              buildInputField(
                text: passwordText, controller: passwordController, isPassword: true,
                obscureText: _obscurePassword,
                onToggleVisibility: (){
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                } ,
              ),
              SizedBox(height: 16),
              buildButton(
                text: isLoading ? "Signing in..." : continueText,
                color: AppColors.primaryColor,
                onPressed: isLoading ? null : _signIn,
              ),
              SizedBox(height: 16),
              buildRow(
                text1: forgetPasswordText,
                text2: resetText,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
