import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// CRUD operations on users

updateUser(String collName, docName, field, var newFieldValue) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).update({field:newFieldValue});
}

// CRUD operations on products

createProduct(String collName, name, description, price, quantity, userId, imgUrl) async {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('products');
  DocumentReference docRef = collectionRef.doc();
  String randomId = docRef.id;
  await FirebaseFirestore.instance.collection(collName).doc(randomId).set({
    'id': randomId,
    'name': name,
    'description': description,
    'price': price,
    'quantity': quantity,
    'owner': userId,
    'imageUrl': imgUrl,
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
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  if (userDoc['cartId'].toString().isEmpty){
    DocumentReference newDoc = FirebaseFirestore.instance.collection('cart').doc();
    String randomId = newDoc.id;
    FirebaseFirestore.instance.collection('cart').doc(randomId).set({
      'id': randomId,
      'items': [],
    });
    updateUser('users', user.uid, 'cartId', randomId);
  }
  userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  DocumentReference cartRef = FirebaseFirestore.instance.collection('cart').doc(userDoc['cartId'].toString());
  DocumentSnapshot doc = await cartRef.get();
  if(doc.exists){
    List<dynamic> itemList = doc['items'];
    bool itemFound = false;
    for (var i = 0; i < itemList.length; i++) {
      if (itemList[i]['productId'] == item['id']) {
        itemList[i]['quantity'] += 1;
        itemFound = true;
        break;
      }
    }

    if(!itemFound){
      itemList.add({
        'productId': item['id'],
        'name': item['name'],
        'price': item['price'],
        'quantity': 1,
        'owner': item['owner'],
        'imageUrl': item['itemUrl']
      });
    }

    await cartRef.update({'items': itemList});
  } else {
    print('Cart doesnot exist');
  }
}

deleteFromCart(var id) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart').doc(id).delete();
}