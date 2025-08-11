import 'dart:convert';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/screens/profile/show_address_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/shared_preference.dart';
import 'package:e_commerce/widgets/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/provider/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/screens/profile/wishlist_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key,required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', base64Image);

        setState(() {
          _webImage = bytes;
        });

      } else {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', base64Image);

        setState(() {
          _webImage = bytes;
        });

      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    Provider.of<ProfileProvider>(context, listen: false).fetchUserProfile(widget.uid);
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');
    if (base64Image != null) {
      setState(() {
        _webImage = base64Decode(base64Image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.user;
    return  Scaffold(
      appBar: AppBar(title: Text("Profile")),
      bottomNavigationBar: buildBottomNavigationBar(context, 3),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _webImage != null ? MemoryImage(_webImage!) : null,
                    child: _webImage == null
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        await _pickImage();
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, size: 16, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.firstName} ${user.lastName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user.email, style: TextStyle(color: Colors.grey[700])),
                        buildInfoRow("Gender",user.gender),
                        buildInfoRow("Age Range",user.ageRange),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showEditProfileDialog(context, user);
                    },
                    child: Text("Edit", style: TextStyle(color: AppColors.primaryColor)),
                  )
                ],
              ),
            ),
            SizedBox(height: 8),
            buildMenuItem(title: 'Address',onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowAddressPage(),));
            }),
            buildMenuItem(title: 'Wishlist',
              onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen(),));
              }
            ),
            buildMenuItem(title: 'Help',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Help section coming soon!')),
                );
              },
            ),
            buildMenuItem(title: 'Support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Support feature coming soon!')),
                );
              },
            ),
            Center(
                child: TextButton(
                  onPressed: () async {
                    await SharedPrefs.saveLoginStatus(false);
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  Widget buildInfoRow(String title, String value) {
    return Row(
      children: [
        Text("$title:", style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(width: 10),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, UserModel user) {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final genderController = TextEditingController(text: user.gender);
    String selectedAgeRange = user.ageRange;

    final _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: "First Name"),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: "Last Name"),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: "Gender"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedAgeRange,
                  decoration: InputDecoration(labelText: "Age Range"),
                  items: _ageRanges.map((age) {
                    return DropdownMenuItem(
                      value: age,
                      child: Text(age),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedAgeRange = newValue!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<ProfileProvider>(context, listen: false)
                    .updateUserProfile(
                  user.uid,
                  firstNameController.text,
                  lastNameController.text,
                  genderController.text,
                  selectedAgeRange,
                );
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

}
