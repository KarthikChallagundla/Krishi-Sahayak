import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/farmer_pages/about.dart';
import 'package:demo_mvp/farmer_pages/crop_doctor.dart';
import 'package:demo_mvp/farmer_pages/machinery.dart';
import 'package:demo_mvp/farmer_pages/my_products.dart';
import 'package:demo_mvp/farmer_pages/soil_test.dart';
import 'package:demo_mvp/farmer_pages/weather_page.dart';
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerPage extends StatefulWidget {
  const FarmerPage({super.key});

  @override
  State<FarmerPage> createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String prodName = "";
  String prodPrice = "";
  String username = "";

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
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [MyProcdutsPage(user: username), WeatherPage(), CropDoctor(), MachineryTools(), SoilTest()];
    final List<String> names = ['My Products', 'Weather', 'Crop Doctor', 'Tools & Rental Services', 'Soil Testing'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text(names[currentIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AboutPage())
              );
            },
            icon: Icon(Icons.info),
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
          ),
        ],
      ),
      body: pages[currentIndex],
      
      floatingActionButton: (currentIndex == 0 || currentIndex == 3) ? FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                backgroundColor: Color.fromRGBO(232, 255, 245, 0.9),
                content: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          key: ValueKey('prodName'),
                          decoration: InputDecoration(
                            hintText: 'Product name',
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(128, 128, 128, 0.3),
                            filled: true,
                          ),
                          validator: (value) {
                            if(value!.isEmpty){
                              return "This field is empty";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            setState(() {
                              prodName = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          key: ValueKey('prodPrice'),
                          decoration: InputDecoration(
                            hintText: 'Product price',
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(128, 128, 128, 0.3),
                            filled: true,
                          ),
                          validator: (value) {
                            if(value!.isEmpty){
                              return "This field is empty";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            setState(() {
                              prodPrice = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: ElevatedButton(
                            onPressed: (){
                              if(_formkey.currentState!.validate()){
                                _formkey.currentState!.save();
                                createProduct('products', prodName, prodName, prodPrice, username);
                                setState(() {
                                  _formkey = GlobalKey<FormState>();
                                });
                              }
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Successfully added'),
                                )
                              );
                            },
                            child: const Text("Add my product"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        },
        child: Icon(Icons.add),
      ) : Container(),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud, size: 25),
            label: 'Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services, size: 25),
            label: 'Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture, size: 30),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science, size: 30),
            label: 'Soil Test',
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