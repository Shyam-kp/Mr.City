import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_city/topbar.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _contactController = TextEditingController();

  String name = 'Updating...';
  String contact = 'Updating...';

  late final String? childId;

  String _imageUrl = 'assets/jinu.jpg';

  Future<void> getData() async {
    final user = FirebaseAuth.instance.currentUser;

    final userId = user?.uid;
    print(userId);
    if (userId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      userDoc.get().then((DocumentSnapshot) {
        if (DocumentSnapshot.exists) {
          print('Exist');
          final userData = DocumentSnapshot.data();
          setState(() {
            name = userData?['name'] ?? 'Name not Found';
            contact = userData?['contact'] ?? 'Contact Not Found';

            _nameController.text=name;
            _contactController.text=contact;

            if (userData?['ImageUrl'] != null) {
              _imageUrl = userData?['ImageUrl'];
            }
          });
        }
      });
    }
  }

  XFile? _selectedImage;

  late ProgressDialog _progressDialog;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/xyz.jpg.jpg'), fit: BoxFit.cover)),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Topbar(),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                              backgroundImage: _selectedImage != null
                                  ? FileImage(File(_selectedImage!.path))
                                  : _imageUrl != null
                                      ? NetworkImage(_imageUrl!)
                                      : const AssetImage('assets/abc.jpg.webp')
                                          as ImageProvider,
                              child: _selectedImage == null && _imageUrl == null
                                  ? const Icon(
                                      Icons.add,
                                      size: 40,
                                      color: Color.fromARGB(255, 134, 134, 134),
                                    )
                                  : null,
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(2555, 139, 181, 203),
                                radius: 18,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 35),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 139, 181, 203),
                      labelText: 'Name',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 24)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      )),
                ),
                const SizedBox(height: 30),
                TextFormField(
                    controller: _contactController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 139, 181, 203),
                        labelText: 'Contact',
                        labelStyle:
                            const TextStyle(color: Color.fromARGB(255, 0, 0, 2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    color: Color.fromARGB(250, 0, 0, 24)),
                              ),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
