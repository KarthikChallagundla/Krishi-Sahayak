
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:flutter/material.dart';

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
                onPressed: (){
                  if(formkey.currentState!.validate()){
                    formkey.currentState!.save();
                    createProduct('products', name, description, price, widget.user);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}