import 'package:e_commerce/screens/favorites_page.dart';
import 'package:e_commerce/screens/home/home_page_screen.dart';
import 'package:e_commerce/screens/notification/notification_page.dart';
import 'package:e_commerce/screens/profile/profile_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Container buildText({required String? text, double? size,FontWeight? fontWeight}) {
  return Container(
    padding: EdgeInsets.only(left: 5),
    child: Text(
      text!,
      style: TextStyle(fontSize: size,fontWeight: fontWeight),
    ),
  );
}

Container buildContainer({required String text}) {
  return Container(
    padding: EdgeInsets.only(left: 5),
    decoration:BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10),
    ) ,
    child: TextField(
      decoration: InputDecoration(
        hintText: text,
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildInputField({
  required String text,
  required TextEditingController controller,
  bool isPassword = false,
  bool obscureText = false,
  VoidCallback? onToggleVisibility,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 6),
      Container(
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '$text',
            suffixIcon: isPassword
              ?IconButton( icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,), onPressed: onToggleVisibility,) : null
          ),
        ),
      ),
    ],
  );
}

Row buildRow({String? text1, String?text2,required VoidCallback onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
          text1!
      ),
      GestureDetector(
        onTap: onTap,
        child: Text(
          text2!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

Container iconContainer({
  required IconData icon,
  required double size,
  required Color color,
  VoidCallback? onTap,
}) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      shape: BoxShape.circle,
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    ),
  );
}

Widget buildButton({
  required String? text,
  required VoidCallback? onPressed,
  Color? color,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
        ),
      ),
      child: Text(
        text!,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
      ),
    ),
  );
}

Widget buildDropdownTile({
  required String title,
  required String selectedValue,
  required List<String> options,
  required ValueChanged<String?> onChanged,
  bool colorDot = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(32),
    ),
    height: 56,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: onChanged,
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: colorDot
                    ? Row(
                  children: [
                    CircleAvatar(radius: 8, backgroundColor: getColorFromName(option)),
                    const SizedBox(width: 8),
                    Text(option),
                  ],
                )
                    : Text(option),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Color getColorFromName(String name) {
  switch (name.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    default:
      return Colors.grey;
  }
}


Widget loadingWidget(){
  return SizedBox(

    height: 100.0,
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
        ),
        height: 100,
      ),
    ),
  );
}

Widget buildQuantityTile({
  required int quantity,
  required VoidCallback onAdd,
  required VoidCallback onRemove,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    height: 56,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(32),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(quantityText),
        Row(
          children: [
            roundButton(Icons.remove, onRemove),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                quantity.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            roundButton(Icons.add, onAdd),
          ],
        ),
      ],
    ),
  );
}


Widget roundButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: AppColors.primaryColor,
      radius: 16,
      child: Icon(icon, size: 16, color: Colors.white),
    ),
  );
}

BottomNavigationBar buildBottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: Colors.grey,
    currentIndex: currentIndex,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
    ],
    onTap: (index) {
      if(index == currentIndex) return;
      switch(index) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageScreen()));
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(),));
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
          break;
        case 3:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)));
          break;
      }
    },
  );
}

Widget buildMenuItem({
  required String title,
  VoidCallback? onTap
}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        GestureDetector(
            onTap: onTap,
            child: Icon(Icons.arrow_forward_ios_rounded, size: 16)
        ),
      ],
    ),
  );
}