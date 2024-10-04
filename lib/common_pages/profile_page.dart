import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/common_pages/about.dart';
import 'package:demo_mvp/common_pages/profile_settings.dart';
import 'package:demo_mvp/farmer_pages/my_tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_mvp/locale_provider.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  
  const ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userEmail = "";
  String imgUrl = "";

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
        userEmail = userDoc['email'];
        imgUrl = userDoc['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen[100]!, Colors.green[300]!], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 55,
              backgroundImage: (imgUrl == '') 
                  ? AssetImage('assets/profile.jpeg') 
                  : NetworkImage(imgUrl) as ImageProvider,
            ),
            SizedBox(height: 12),
            Text(
              widget.username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 2),
            Text(
              widget.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[600],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                additionalButtons(Icons.work_outline, "Passenger\nDocuments"),
                additionalButtons(Icons.notifications_outlined, "Tracker\nNotifications"),
                additionalButtons(Icons.help_outline_outlined, "Help Center"),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), 
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      buildSettingsRow(Icons.language_rounded, 'Language', () {
                        showLanguageMenu(localeProvider);
                      }),
                      SizedBox(height: 15,),
                      buildSettingsRow(Icons.shopping_cart, 'My Orders', () {
                        // Implement My Orders functionality
                      }),
                      SizedBox(height: 18,),
                      buildSettingsRow(Icons.agriculture, 'My Tools', () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyTools(user: userEmail)));
                      }),
                      SizedBox(height: 18,),
                      buildSettingsRow(Icons.edit, 'Edit Profile', () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileSettings()));
                      }),
                      SizedBox(height: 15,),
                      buildSettingsRow(Icons.notifications_active, 'Notification Settings', () {
                        // Implement Notification Settings functionality
                      }),
                      SizedBox(height: 15,),
                      buildSettingsRow(Icons.info_outline, 'About Us', () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutPage()));
                      }),
                      SizedBox(height: 15,),
                      buildSettingsRow(Icons.logout, 'Logout', () {
                        showLogoutDialog();
                      }),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsRow(IconData icon, String title, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.green[600]),
          SizedBox(width: 16,),
          Expanded(child: Text(title, style: TextStyle(fontSize: 18, color: Colors.brown[700]))),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void showLanguageMenu(LocaleProvider localeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.green[50], // Background color for modal
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English', style: TextStyle(color: Colors.brown[800])),
                onTap: () {
                  localeProvider.setLocale(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('తెలుగు', style: TextStyle(color: Colors.brown[800])),
                onTap: () {
                  localeProvider.setLocale(Locale('te'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('हिन्दी', style: TextStyle(color: Colors.brown[800])),
                onTap: () {
                  localeProvider.setLocale(Locale('hi'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('انگریزی', style: TextStyle(color: Colors.brown[800])),
                onTap: () {
                  localeProvider.setLocale(Locale('ur'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('தமிழ்', style: TextStyle(color: Colors.brown[800])),
                onTap: () {
                  localeProvider.setLocale(Locale('ta'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('മലയാളം', style: TextStyle(color: Colors.brown[800])),
                onTap: () {
                  localeProvider.setLocale(Locale('ml'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure to logout?', style: TextStyle(color: Colors.brown[800])),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.green[600])),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: Text('Yes', style: TextStyle(color: Colors.red[600])),
            ),
          ],
        );
      },
    );
  }

  Widget additionalButtons(IconData icon, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green[600], // Button color
          child: IconButton(
            onPressed: () {},
            icon: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        Text(name, textAlign: TextAlign.center, style: TextStyle(color: Colors.brown[800])),
      ],
    );
  }
}
