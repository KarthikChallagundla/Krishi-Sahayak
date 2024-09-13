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
    return Scaffold(
      appBar: AppBar(
        title: Text("Crops"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          itemCount: cropsList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> crop = cropsList[index];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CropInfo(crop: crop)));
              },
              child: Card(
                child: ListTile(
                  title: Text(crop['Name']),
                  subtitle: Text(crop['Category']),
                ),
              ),
            );
          },
        ),
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
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('${crop['Name']} Details'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: keys.length - 2,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Text(keys[index + 2].toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder(
                    future: translateText(crop[keys[index + 2]], currentLocale.languageCode),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(),);
                      } else if (snapshot.hasError) {
                        return Text(crop[keys[index+2]]);
                      } else {
                        return Text(snapshot.data ?? crop[keys[index+2]]);
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
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