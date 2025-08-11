import 'package:e_commerce/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditAddressPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> addressData;

  const EditAddressPage({
    super.key,
    required this.docId,
    required this.addressData,
  });

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipController;

  @override
  void initState() {
    super.initState();
    streetController = TextEditingController(text: widget.addressData['street']);
    cityController = TextEditingController(text: widget.addressData['city']);
    stateController = TextEditingController(text: widget.addressData['state']);
    zipController = TextEditingController(text: widget.addressData['zip']);
  }

  Future<void> updateAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(widget.docId)
        .update({
      'street': streetController.text.trim(),
      'city': cityController.text.trim(),
      'state': stateController.text.trim(),
      'zip': zipController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address updated successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField(streetController, "Street"),
            const SizedBox(height: 15),
            _buildField(cityController, "City"),
            const SizedBox(height: 15),
            _buildField(stateController, "State"),
            const SizedBox(height: 15),
            _buildField(zipController, "Zip Code", keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Save", style: TextStyle(fontSize: 16, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
