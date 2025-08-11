import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController zipController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Add Address',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(controller: streetController, hint: 'Street Address'),
            const SizedBox(height: 15),
            _buildTextField(controller: cityController, hint: 'City'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(controller: stateController, hint: 'State'),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTextField(controller: zipController, hint: 'Zip Code'),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final uid = FirebaseAuth.instance.currentUser?.uid;

                  if (uid == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('addresses')
                        .add({
                      'street': streetController.text.trim(),
                      'city': cityController.text.trim(),
                      'state': stateController.text.trim(),
                      'zip': zipController.text.trim(),
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address saved successfully")));
                    Navigator.pop(context); // Go back after saving
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
