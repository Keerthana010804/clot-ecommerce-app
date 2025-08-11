import 'package:e_commerce/screens/basic_details_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/shared_preference.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'signin_screen.dart';
import 'forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                      MaterialPageRoute(builder: (context) => SignInScreen(),));
                },
              ),
              SizedBox(height: 16,),
              buildText(text: createAccountText, fontWeight: FontWeight.bold, size: 32),
              SizedBox(height: 40,),
              buildInputField(text: firstNameText, controller: firstNameController),
              SizedBox(height: 12),
              buildInputField(text: lastNameText, controller: lastNameController),
              SizedBox(height: 12),
              buildInputField(text: emailAddressText, controller: emailController),
              SizedBox(height: 12),
              buildInputField(
                  text: passwordText, controller: passwordController, isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: (){
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  } ,
              ),
              SizedBox(height: 40,),
              buildButton(
                  text: continueText,
                  color: AppColors.primaryColor,
                onPressed: () async {
                  final firstName = firstNameController.text.trim();
                  final lastName = lastNameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
        
                  if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
                    return;
                  }
        
                  try {
                    // 1. Create user in Firebase Auth
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
        
                    // 2. Store user data in Firestore
                    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                      'uid': userCredential.user!.uid,
                      'firstName': firstName,
                      'lastName': lastName,
                      'email': email,
                      'createdAt': DateTime.now(),
                    });
        
                    if(userCredential.user != null){
                      SharedPrefs.saveLoginStatus(true);
                    }
        
                    // 3. Navigate to next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasicDetailsScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                }
                ,
              ),
              SizedBox(height: 40),
              buildRow(
                  text1: forgetPasswordText,
                  text2: resetText,
                  onTap: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ForgetPassword(),));
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
