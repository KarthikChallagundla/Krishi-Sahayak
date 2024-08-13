import 'package:demo_mvp/common_pages/about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_mvp/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String userRole;
  const ProfilePage({super.key, required this.username, required this.userRole});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final selectedLocale = localeProvider.locale;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              child: Image.asset('assets/krishi_sahayak.png'),
            ),
            SizedBox(height: 16),
            Text(
              widget.username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.userRole,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Divider(height: 30, thickness: 2, color: Colors.green[300]),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.language, color: Colors.blue),
                title: Text(AppLocalizations.of(context)!.changeLanguage),
                trailing: DropdownButton<Locale>(
                  value: selectedLocale,
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      localeProvider.setLocale(newLocale);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('te'),
                      child: Text('తెలుగు'),
                    ),
                    DropdownMenuItem(
                      value: Locale('hi'),
                      child: Text('हिंदी'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ur'),
                      child: Text('اردو'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ta'),
                      child: Text('தமிழ்'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ml'),
                      child: Text('മലയാളം'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
                leading: Icon(Icons.info, color: Colors.green),
                title: Text(AppLocalizations.of(context)!.aboutUs),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              FirebaseAuth.instance.signOut();
                            },
                            child: Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red, // Text color
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.logout),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
