import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:demo_mvp/user_pages/cart_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('User Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
            },
            icon: Icon(Icons.shopping_bag),
          ),
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Do you want to exit?'),
                    actions: [
                      TextButton(
                        onPressed: (){Navigator.of(context).pop();},
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text('Exit'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            } else {
              final prodList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: prodList.length,
                itemBuilder: (context, index) {
                  var product = prodList[index];
                  return Card(
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Text(product['price']),
                      trailing: IconButton(
                        onPressed: (){
                          addToCart({'id':product.id, 'name':product['name'], 'price':product['price'], 'owner':product['owner']});
                        },
                        icon: Icon(Icons.add_shopping_cart),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}