import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to see your cart.')),
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading cart items'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Your cart is empty'));
            } else {
              var cartItems = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var cartItem = cartItems[index];
                        var itemName = cartItem['itemName'] ?? 'Unnamed Item';
                        var itemPrice = cartItem['itemPrice']?.toString() ?? '0';
                        var quantity = cartItem['quantity'] ?? 0;

                        return Card(
                          child: ListTile(
                            title: Text(itemName),
                            subtitle: Text('\$${itemPrice}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(quantity.toString()),
                                IconButton(
                                  onPressed: () {
                                    deleteFromCart(cartItem.id);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () {
                        
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Proceed to Checkout', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
