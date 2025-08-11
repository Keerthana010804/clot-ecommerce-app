class Address {
  final String city;
  final String state;
  final String street;
  final String zip;

  Address({required this.city, required this.state, required this.street, required this.zip});

  factory Address.fromFirestore(Map<String, dynamic> data) {
    return Address(
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      street: data['street'] ?? '',
      zip: data['zip'] ?? '',
    );
  }

  @override
  String toString() {
    return "$street, $city, $state - $zip";
  }
}
