import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/common_pages/profile_page.dart';
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:demo_mvp/user_pages/cart_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  String username = '';
  String userRole = '';
  String userEmail = "";
  int currentIndex = 0;

  DocumentSnapshot<Object?>? userDocument;


  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        username = userDoc['username'];
        userRole = userDoc['role'];
        userEmail = userDoc['email'];
        userDocument = userDoc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [CartPage(), ProfilePage(username: username, email: userEmail,)];
    final List<String> names = ['Cart', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: (currentIndex != 0) ? Text(names[currentIndex - 1]) : Text('User Page'),
        centerTitle: true,
      ),
      body: (currentIndex != 0) ? pages[currentIndex - 1] : Container(
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
                      title: Text("${product['name']} ${(int.parse(product['quantity']) == 0) ? "Out of stock" : ""}"),
                      subtitle: Text("${product['description']}\nPrice : ${product['price']}"),
                      trailing: IconButton(
                        onPressed: () async {
                          await addToCart({'id':product.id, 'name':product['name'], 'price':product['price'], 'owner':product['owner']});
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 25),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 25),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}