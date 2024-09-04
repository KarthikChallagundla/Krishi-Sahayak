import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay razorpay;
  num amount = 0;

  DocumentSnapshot? userDocument;
  DocumentSnapshot? userCart;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _getCartItems();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  Future<void> _getCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        DocumentSnapshot cart = await FirebaseFirestore.instance.collection('cart').doc(userDoc['cartId']).get();

        print(cart['items']);
        setState(() {
          userDocument = userDoc;
          userCart = cart;
          cartItems = List<Map<String, dynamic>>.from(cart['items'] ?? []);
          // Calculate total amount
          amount = cartItems.fold(0, (sum, item) => sum + (item['itemPrice'] ?? 0) * (item['quantity'] ?? 0));
        });
      } catch (e) {
        print('Error fetching cart items: $e');
      }
    }
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  void deleteFromCart(String itemId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('carts').doc(user.uid).update({
          'items': FieldValue.arrayRemove([{'id': itemId}]),
        });
        _getCartItems(); // Refresh cart items
      } catch (e) {
        print('Error deleting item: $e');
      }
    }
  }

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
        child: Column(
          children: [
            Expanded(
              child: cartItems.isEmpty
                  ? Center(child: Text('Your cart is empty.'))
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var cartItem = cartItems[index];
                        var itemName = cartItem['name'] ?? 'Unnamed Item';
                        var itemPrice = cartItem['price']?.toString() ?? '0';
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
                                    deleteFromCart(cartItem['id']);
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
                  try {
                    razorpay.open({
                      'key': 'rzp_test_zAmhqVguMCl1RS',
                      'amount': amount * 100,
                      'name': 'Karthik',
                      'description': 'Fine T-Shirt',
                      'theme': {"color": "#00FF00"},
                      'prefill': {
                        'contact': '8919393266',
                        'email': 'karthikchallagundla18@gmail.com'
                      },
                    });
                  } catch (e) {
                    print('Error opening Razorpay: $e');
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Proceed to Checkout', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Success: ${response.paymentId}')),
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Error: ${response.code}')),
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }
}
