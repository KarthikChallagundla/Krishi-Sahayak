import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<String> signUp(String username, String email, String password, String role, {phone='', address='', imageUrl=''}) async {
  if (role == ''){
    return 'Add your role';
  }
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'username': username,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
      'imageUrl': imageUrl,
      'cartId': '',
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
    await FirebaseAuth.instance.signInWithEmailAndPassword(
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

Future<String> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await googleSignIn.signOut();

  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return 'Sign-in was aborted by the user';
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = userCredential.user;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': user.displayName,
          'email': user.email,
          'role': '',
          'imageUrl': user.photoURL,
          'phone': '',
          'address': '',
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'lastSignInTime': user.metadata.lastSignInTime,
        });
      }
    }
    return "Successfully Completed";
  } on FirebaseAuthException catch (e) {
    return e.message ?? "An unknown error occurred";
  }
}