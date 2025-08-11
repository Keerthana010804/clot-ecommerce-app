import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/provider/auth_provider.dart';
import 'package:e_commerce/screens/home/home_page_screen.dart';
import 'package:e_commerce/screens/signin_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_widgets.dart';

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  String selectedGender = "";
  bool _isExpanded = false;
  String? _selectedAgeRange;
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await authProvider.signOut();
                Navigator.push(context, MaterialPageRoute(builder:(context) => SignInScreen(),));
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(top:100,left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(text: tellUsAboutYourselfText, size: 24,fontWeight: FontWeight.bold),
              SizedBox(height: 40,),
              buildText(text: whoDoYouShopForText, size: 16, fontWeight: FontWeight.normal),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = menText;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: selectedGender == menText
                              ? AppColors.primaryColor
                              : Colors.grey.shade200,
                        ),
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            menText,
                            style: TextStyle(
                              color: selectedGender == menText
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = womenText;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: selectedGender == womenText
                              ? AppColors.primaryColor
                              : Colors.grey.shade200,
                        ),
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            womenText,
                            style: TextStyle(
                              color: selectedGender == womenText
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              buildText(text: howOldAreYouText,size: 16,fontWeight: FontWeight.normal),
              SizedBox(height: 16,),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedAgeRange ?? ageRangeText,
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Custom Expandable Options
                  if (_isExpanded)
                    Column(
                      children: _ageRanges.map((range) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAgeRange = range;
                              _isExpanded = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(top:5,bottom: 5),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: _selectedAgeRange == range
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade100,
                            ),
                            child: Text(
                              range,
                              style: TextStyle(
                                color: _selectedAgeRange == range
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: buildButton(
              text: finishText,
              color: AppColors.primaryColor,
              onPressed: () async {
                if (selectedGender.isEmpty || _selectedAgeRange == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select gender and age range')),
                  );
                  return;
                }

                try {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                      'gender': selectedGender,
                      'ageRange': _selectedAgeRange,
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving data: $e')),
                  );
                }
              }

          ),
        )
    );
  }
}
