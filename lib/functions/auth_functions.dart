import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> signUp(String username, String email, String password, String role) async {
  if (role == ''){
    return 'Add your role';
  }
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'username': username,
      'email': email,
      'role': role,
    });

    return "Successfully Signed Up";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else if (e.code == 'network-request-failed') {
      return 'No Internet Connection';
    } else {
      return 'An unknown error occurred: ${e.message}';
    }
  }
}

Future<String> signIn(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return "Successfully Logged In";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'invalid-credential') {
      return 'Password is incorrect.';
    } else if (e.code == 'network-request-failed') {
      return 'No Internet Connection.';
    } else {
      return "An unknown error occured";
    }
  }
}
