import 'package:demo_mvp/functions/auth_functions.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DetailsPage extends StatefulWidget {
  final String email;
  final String password;
  final String role;
  const DetailsPage({super.key, required this.email, required this.password, required this.role});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final formkey = GlobalKey<FormState>();
  String username = '';
  String phone = "";
  String address = "";
  late String role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    role = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    username = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your phone number';
                //   }
                //   if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                //     return 'Please enter a valid 10-digit phone number';
                //   }
                //   return null;
                // },
                onSaved: (newValue) {
                  setState(() {
                    phone = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    address = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Radio(
                    value: "Farmer",
                    groupValue: role,
                    onChanged: (value){
                      setState(() {
                        role = "Farmer";
                      });
                    },
                  ),
                  Text('Farmer', style: TextStyle(fontSize: 20),),
                  Radio(
                    value: "User",
                    groupValue: role,
                    onChanged: (value){
                      setState(() {
                        role = "User";
                      });
                    },
                  ),
                  Text('User', style: TextStyle(fontSize: 20),),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if(formkey.currentState!.validate()){
                    formkey.currentState!.save();
                    String message;
                    message = await signUp(username, widget.email, widget.password, role, phone: phone, address: address);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        showCloseIcon: true,
                        behavior: SnackBarBehavior.floating,
                        content: Text(message),
                      )
                    );
                    if(message == "Successfully Signed Up"){
                      Navigator.of(context).pop();
                    }
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