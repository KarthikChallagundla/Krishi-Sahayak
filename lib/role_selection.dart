import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/farmer_pages/farmer_page.dart';
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:demo_mvp/user_pages/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {

  String uid = '';

  @override
  void initState(){
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        uid = userDoc['uid'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please select your role'),
            TextButton(
              onPressed: (){
                updateUser('users', uid, 'role', 'Farmer');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FarmerPage()));
              },
              child: Text('Continue as Farmer'),
            ),
            TextButton(
              onPressed: (){
                updateUser('users', uid, 'role', 'User');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserPage()));
              },
              child: Text('Continue as User'),
            ),
          ],
        ),
      ),
    );
  }
}