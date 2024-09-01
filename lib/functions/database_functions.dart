import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// CRUD operations on products

createProduct(String collName, name, description, price, userId) async {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('products');
  DocumentReference docRef = collectionRef.doc();
  String randomId = docRef.id;
  await FirebaseFirestore.instance.collection(collName).doc(randomId).set({
    'id': randomId,
    'name': name,
    'description': description,
    'price': price,
    'owner': userId,
  });
}

updateProduct(String collName, docName, field, var newFieldValue) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).update({field:newFieldValue});
}

deleteProduct(String collName, docName) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).delete();
}

// CRUD operations on cart items

addToCart(Map<String, dynamic> item) async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentReference cartRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart').doc(item['id']);
  DocumentSnapshot doc = await cartRef.get();
  if (doc.exists) {
    cartRef.update({
      'quantity': FieldValue.increment(1),
    });
  } else {
    cartRef.set({
      'itemName': item['name'],
      'itemPrice': item['price'],
      'quantity': 1,
    });
  }
}

deleteFromCart(var id) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart').doc(id).delete();
}