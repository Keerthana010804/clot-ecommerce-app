import 'package:e_commerce/screens/profile/add_address_screen.dart';
import 'package:e_commerce/screens/profile/edit_address_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ShowAddressPage extends StatelessWidget {
  const ShowAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Addresses'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No addresses found"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ListTile(
                  title: Text("${data['street']}, ${data['city']}"),
                  subtitle: Text("${data['state']} - ${data['zip']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditAddressPage(
                                docId: docs[index].id,
                                addressData: data,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Address'),
                              content: const Text('Are you sure you want to delete this address?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('addresses')
                                .doc(docs[index].id)
                                .delete();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  AddAddressPage()),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child:  Icon(Icons.add),
        tooltip: "Add New Address",
      ),
    );
  }
}
