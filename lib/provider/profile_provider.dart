
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> fetchUserProfile(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromJson(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  /// ✅ Add this function to update user profile in Firestore
  Future<void> updateUserProfile(
      String uid,
      String firstName,
      String lastName,
      String gender,
      String ageRange,
      ) async {
    try {
      final updatedData = {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'ageRange': ageRange,
      };

      await FirebaseFirestore.instance.collection('users').doc(uid).update(updatedData);

      // Also update local model
      if (_user != null) {
        _user = UserModel(
          uid: _user!.uid,
          email: _user!.email,
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          ageRange: ageRange,
          // include other fields if any
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }
}
