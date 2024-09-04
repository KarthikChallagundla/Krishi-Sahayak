import 'package:demo_mvp/common_pages/about.dart';
import 'package:demo_mvp/common_pages/profile_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:demo_mvp/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfilePage extends StatefulWidget {
  // final DocumentSnapshot<Object?> userDocument;
  final String username;
  final String email;
  const ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    TextStyle mainStyle = TextStyle(
      fontSize: 18,
    );
    TextStyle buttonStyle = TextStyle(
      fontSize: 16,
      color: Colors.blue
    );

    return Scaffold(
      body: Container(
        color: Colors.grey[600],
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 55,
              child: Image.asset('assets/krishi_sahayak.png'),
            ),
            SizedBox(height: 12),
            Text(
              widget.username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              widget.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 8),
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
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(Icons.language_rounded, size: 28,),
                            SizedBox(width: 16,),
                            Expanded(child: Text('Language', style: mainStyle,)),
                            PopupMenuButton(
                              child: Text(AppLocalizations.of(context)!.language, style: buttonStyle,),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      localeProvider.setLocale(Locale('en'));
                                    },
                                    child: Text('English'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      localeProvider.setLocale(Locale('te'));
                                    },
                                    child: Text('తెలుగు'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      localeProvider.setLocale(Locale('hi'));
                                    },
                                    child: Text('हिन्दी'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      localeProvider.setLocale(Locale('ur'));
                                    },
                                    child: Text('انگریزی'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      localeProvider.setLocale(Locale('ta'));
                                    },
                                    child: Text('தமிழ்'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      localeProvider.setLocale(Locale('ml'));
                                    },
                                    child: Text('മലയാളം'),
                                  ),
                                ];
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Icon(Icons.money_rounded, size: 28,),
                            SizedBox(width: 16,),
                            Expanded(child: Text('My Orders', style: mainStyle,)),
                          ],
                        ),
                        SizedBox(height: 18,),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileSettings()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 28,),
                              SizedBox(width: 16,),
                              Expanded(child: Text('Edit Profile', style: mainStyle,)),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Icon(Icons.notifications_active, size: 28,),
                            SizedBox(width: 16,),
                            Expanded(child: Text('Notification Settings', style: mainStyle,)),
                          ],
                        ),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutPage()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 28,),
                              SizedBox(width: 16,),
                              Expanded(child: Text('About Us', style: mainStyle,)),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Are you sure to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No', style: TextStyle(color: Colors.green),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes', style: TextStyle(color: Colors.red),),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 28,),
                              SizedBox(width: 16,),
                              Expanded(child: Text('Logout', style: mainStyle,)),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  additionalButtons(IconData icon, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: (){},
            icon: Icon(icon),
          ),
        ),
        SizedBox(height: 10,),
        Text(name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
      ],
    );
  }
}
