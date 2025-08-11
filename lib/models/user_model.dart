class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String ageRange;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.ageRange,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: json['gender'],
      ageRange: json['ageRange'],
    );
  }
}
