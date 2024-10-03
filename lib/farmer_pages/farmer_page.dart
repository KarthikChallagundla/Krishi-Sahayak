import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/farmer_pages/crop_disease.dart';
import 'package:demo_mvp/farmer_pages/crop_doctor.dart';
import 'package:demo_mvp/farmer_pages/crops_page.dart';
import 'package:demo_mvp/farmer_pages/machinery.dart';
import 'package:demo_mvp/farmer_pages/market_prices.dart';
import 'package:demo_mvp/farmer_pages/my_products.dart';
import 'package:demo_mvp/common_pages/profile_page.dart';
import 'package:demo_mvp/farmer_pages/schemes.dart';
import 'package:demo_mvp/farmer_pages/soil_test.dart';
import 'package:demo_mvp/farmer_pages/weather_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class FarmerPage extends StatefulWidget {
  const FarmerPage({super.key});

  @override
  State<FarmerPage> createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {
  String userId = "";
  String username = "";
  String userRole = "";
  String userEmail = "";

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userId = userDoc['uid'];
        username = userDoc['username'];
        userRole = userDoc['role'];
        userEmail = userDoc['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      WeatherPage(),
      MachineryTools(),
      SoilTest(),
      ProfilePage(username: username, email: userEmail),
    ];
    final List<String> names = [
      AppLocalizations.of(context)!.weather,
      AppLocalizations.of(context)!.tools,
      AppLocalizations.of(context)!.soilTest,
      AppLocalizations.of(context)!.profile,
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          currentIndex == 0
              ? AppLocalizations.of(context)!.dashboard
              : names[currentIndex - 1],
          style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: (currentIndex != 0)
          ? pages[currentIndex - 1]
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerSlider(),
                  const SizedBox(height: 20),
                  _buildProductSection(context, "Featured Products"),
                  const SizedBox(height: 20),
                  _buildGridSection(context),
                  const SizedBox(height: 20), 
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildBottomNavItem(Icons.home, AppLocalizations.of(context)!.home),
          _buildBottomNavItem(Icons.cloud, AppLocalizations.of(context)!.forecast),
          _buildBottomNavItem(Icons.agriculture, AppLocalizations.of(context)!.tools),
          _buildBottomNavItem(Icons.science, AppLocalizations.of(context)!.soilTest),
          _buildBottomNavItem(Icons.person, AppLocalizations.of(context)!.profile),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
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

  Widget _buildBannerSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/banner${i.toString()}.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildProductSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Example product count
              itemBuilder: (context, index) {
                return _buildProductCard(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/sprayer.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sprayer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            '\$100',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildDashboardCard(context, Icons.shopping_bag, 'Sell Products', () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyProductsPage(user: userId)));
          }),
          _buildDashboardCard(context, Icons.public, 'Govt Schemes', () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Schemes()));
          }),
          _buildDashboardCard(context, Icons.price_change, 'Market Prices', () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MarketPrices()));
          }),
          _buildDashboardCard(context, Icons.medical_services, 'Crop Doctor', () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CropDoctor()));
          }),
          _buildDashboardCard(context, Icons.grass, 'Crop Details', () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CropsPage()));
          }),
          _buildDashboardCard(context, Icons.bug_report, 'Crop Disease', () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CropDisease()));
          }),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.lime],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
