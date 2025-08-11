import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/provider/auth_provider.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/asset_constants.dart';
import 'package:e_commerce/utils/internet_check.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_widgets.dart';
import 'basic_details_screen.dart';
import 'signin_screen_1.dart';
import 'create_account.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  
  
  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  void checkNetwork() async {
    bool isConnected = await isNetworkAvailable();
    if (!isConnected) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("No Internet Connection"),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Ok"))
            ],
          );
        },
      );
    }
  }
  
  
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(text: signInText,fontWeight: FontWeight.bold,size: 32),
              SizedBox(height: 40,),
              buildInputField(text: emailAddressText, controller: emailController),
              SizedBox(height: 16),
              buildButton(
                  text: continueText,
                  color: AppColors.primaryColor,
                onPressed: () async {
                  String email = emailController.text.trim();
                  if (email.isEmpty) {
                    EasyLoading.showError("Please enter your email");
                    return;
                  }
        
                  EasyLoading.show(status: 'Checking...');
                  try {
                    final snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: email)
                        .limit(1)
                        .get();
        
                    EasyLoading.dismiss();
        
                    if (snapshot.docs.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen1(email: email,)),
                      );
                    } else {
                      // Email not found
                      EasyLoading.showError("User not available. Please create one.");
                    }
                  } catch (e) {
                    EasyLoading.dismiss();
                    EasyLoading.showError("Something went wrong. Try again.");
                    print("Firestore error: $e");
                  }
                },
        
              ),
              SizedBox(height: 16),
              buildRow(
                text1: doNotHaveAccountText,
                text2: createOneText,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount(),));
                },
              ),
              SizedBox(height: 24),
              socialButton(
                icon: Icons.apple,
                text: continueWithApple
              ),
              SizedBox(height: 16),
              socialButton(
                image: AssetConstants.googleImage,
                text: continueWithGoogle,
                onTap: () async {
                  print("Google signin");
                    EasyLoading.show(status: 'loading...');
                    await authProvider.signInWithGoogle();
                    EasyLoading.dismiss();
                    if(user != null){
                      print("User ${user.email}");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BasicDetailsScreen(),));
                    }
        
                }
              ),
              SizedBox(height: 16),
              socialButton(
                image: AssetConstants.facebookImage,
                text: continueWithFacebook,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget socialButton({
    IconData? icon,
    String? image,
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 16,
              child: icon != null
                  ? Icon(icon, size: 26)
                  : image != null
                  ? Image.asset(image, height: 24, width: 24)
                  : SizedBox.shrink(),
            ),
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
