import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final _emailController = TextEditingController();

  bool loading = false;

  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _usernameController.text = userDoc['username'] ?? '';
          _addressController.text = userDoc['address'] ?? '';
          _phoneController.text = userDoc['phone'] ?? '';
          _imgUrlController.text = userDoc['imageUrl'] ?? '';
          _emailController.text = userDoc['email'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'username': _usernameController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'imageUrl': _imgUrlController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[700], // Dark green for the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: (_imgUrlController.text == '') 
                          ? AssetImage('assets/profile.jpeg') as ImageProvider 
                          : NetworkImage(_imgUrlController.text) as ImageProvider,
                      child: (loading) 
                          ? CircularProgressIndicator() 
                          : Container(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.green[600], // Button color
                        child: IconButton(
                          onPressed: () async {
                            XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              File imageFile = File(image.path);
                              try {
                                setState(() {
                                  loading = true;
                                });
                                String fileName = _emailController.text;
                                Reference ref = FirebaseStorage.instance.ref().child('user_photos/$fileName.jpg');
                                UploadTask uploadTask = ref.putFile(imageFile);
                                await uploadTask.whenComplete(() => null);
                                String downloadUrl = await ref.getDownloadURL();
                                setState(() {
                                  loading = false;
                                  _imgUrlController.text = downloadUrl;
                                });
                              } catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                print('Error uploading image: $e');
                              }
                            }
                          },
                          icon: Icon(Icons.edit, size: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              buildTextField(_usernameController, 'Username', Icons.person),
              buildTextField(_addressController, 'Address', Icons.location_on),
              buildTextField(_phoneController, 'Phone', Icons.phone, keyboardType: TextInputType.phone),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Button color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: Text('Save Changes', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText, IconData icon, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.green[600]), // Icon color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green[400]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          return null;
        },
      ),
    );
  }
}