import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/farmer_pages/crop_doctor.dart';
import 'package:demo_mvp/farmer_pages/machinery.dart';
import 'package:demo_mvp/farmer_pages/market_prices.dart';
import 'package:demo_mvp/farmer_pages/my_products.dart';
import 'package:demo_mvp/farmer_pages/profile_page.dart';
import 'package:demo_mvp/farmer_pages/schemes.dart';
import 'package:demo_mvp/farmer_pages/soil_test.dart';
import 'package:demo_mvp/farmer_pages/weather_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class FarmerPage extends StatefulWidget {
  const FarmerPage({super.key});

  @override
  State<FarmerPage> createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {

  String prodName = "";
  String prodPrice = "";
  String username = "";
  String userRole = "";

  int currentIndex = 0;

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
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [WeatherPage(), MachineryTools(), SoilTest(), ProfilePage(username: username, userRole: userRole,)];
    final List<String> names = [AppLocalizations.of(context)!.weather, AppLocalizations.of(context)!.tools, AppLocalizations.of(context)!.soilTest, AppLocalizations.of(context)!.profile];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: (currentIndex == 0) ? Text(AppLocalizations.of(context)!.dashboard) : Text(names[currentIndex - 1]),
        centerTitle: true,
      ),
      body: (currentIndex != 0) ? pages[currentIndex - 1] : Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              tileColor: const Color.fromARGB(255, 241, 231, 231),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyProcdutsPage(user: username)));
                },
                child: Text(AppLocalizations.of(context)!.sellProducts, style: TextStyle(fontSize: 16),),
              ),
            ),
            SizedBox(height: 10,),
             ListTile(
              tileColor: const Color.fromARGB(255, 241, 231, 231),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Schemes()));
                },
                child: Text(AppLocalizations.of(context)!.governmentSchemes, style: TextStyle(fontSize: 16),),
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              tileColor: const Color.fromARGB(255, 241, 231, 231),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MarketPrices()));
                },
                child: Text(AppLocalizations.of(context)!.marketPrices, style: TextStyle(fontSize: 16),),
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              tileColor: const Color.fromARGB(255, 241, 231, 231),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CropDoctor()));
                },
                child: Text(AppLocalizations.of(context)!.cropDoctor, style: TextStyle(fontSize: 16),),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud, size: 25),
            label: AppLocalizations.of(context)!.forecast,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture, size: 30),
            label: AppLocalizations.of(context)!.tools,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science, size: 30),
            label: AppLocalizations.of(context)!.soilTest,
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