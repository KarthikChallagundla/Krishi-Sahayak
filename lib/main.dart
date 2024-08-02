import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/farmer_pages/farmer_page.dart';
import 'package:demo_mvp/login_page.dart';
import 'package:demo_mvp/user_pages/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if(userSnapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(userSnapshot.hasData && userSnapshot.data!.exists){
                      String role = userSnapshot.data!['role'];
                      if(role == 'Farmer'){
                        return FarmerPage();
                      } else if (role == 'User'){
                        return UserPage();
                      } else {
                        return LoginPage();
                      }
                    } else {
                      return LoginPage();
                    }
                  },
                );
              } else {
                return LoginPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
