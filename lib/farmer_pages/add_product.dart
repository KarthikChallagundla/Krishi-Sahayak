
import 'dart:io';

import 'package:demo_mvp/functions/database_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductsPage extends StatefulWidget {
  final String user;
  const AddProductsPage({super.key, required this.user});

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String name = "";
  String description = "";
  String price = "";
  String quantity = "";
  String email = "";
  File imgFile = File('');

  bool loading = false;

  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: (imgFile.path == '') ? AssetImage('assets/profile.jpeg') as ImageProvider : FileImage(imgFile) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: () async {
                              XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              setState(() {
                                imgFile = File(image!.path);
                              });
                            },
                            icon: Icon(Icons.edit, size: 25,)
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    name = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    description = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    price = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    quantity = newValue!;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if(formkey.currentState!.validate()){
                    formkey.currentState!.save();
                    try {
                      setState(() {
                        loading = true;
                      });
                      String fileName = '$name by ${widget.user}';
                      Reference ref = FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
                
                      UploadTask uploadTask = ref.putFile(imgFile);
                      await uploadTask.whenComplete(() => null);
                
                      String downloadUrl = await ref.getDownloadURL();
                      setState(() {
                        loading = false;
                      });
                      createProduct('products', name, description, price, quantity, widget.user, downloadUrl);
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error uploading image: $e');
                    }
                  }
                },
                child: (loading) ? CircularProgressIndicator() : Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}