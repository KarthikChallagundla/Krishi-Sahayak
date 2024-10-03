import 'package:demo_mvp/database/crop_data.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  List<Map<String, dynamic>> cropsList = cropData;

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;
    // Set the number of columns based on screen width
    int crossAxisCount = (screenWidth / 180).floor(); // Adjust the divisor for desired width per item

    return Scaffold(
      appBar: AppBar(
        title: Text("Crops"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Set the number of columns dynamically
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: cropsList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> crop = cropsList[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CropInfo(crop: crop),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        'assets/crop.jpg', // Ensure your crop data includes the Image URL
                        fit: BoxFit.cover,
                        height: 100, // Set a fixed height for images
                        width: double.infinity, // Full width of the card
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop['Name'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            crop['Category'],
                            style: TextStyle(color: Colors.green[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add crop logic
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}

class CropInfo extends StatefulWidget {
  final Map<String, dynamic> crop;
  const CropInfo({super.key, required this.crop});

  @override
  State<CropInfo> createState() => _CropInfoState();
}

class _CropInfoState extends State<CropInfo> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> crop = widget.crop;
    List<String> keys = crop.keys.toList();
    Locale currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('${crop['Name']} Details'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: keys.length - 2,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                keys[index + 2].toUpperCase(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FutureBuilder(
                    future: translateText(crop[keys[index + 2]], currentLocale.languageCode),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text(crop[keys[index + 2]]);
                      } else {
                        return Text(snapshot.data ?? crop[keys[index + 2]], style: TextStyle(fontSize: 16));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<String> translateText(String message, String translateTo) async {
  GoogleTranslator translator = GoogleTranslator();
  var translation = await translator.translate(message, to: translateTo);
  return translation.text;
}
