import 'package:flutter/material.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {

  List<Map<String, dynamic>> cropsList = [
    {
      "name":"Crop Name 1",
      "description":"Description of crop",
      "Sowing":"Content for Sowing",
      "Ideal Growth Conditions":"Content for growth Conditions",
      "Germination":"Content for germination",
      "Fertilisation":"Content for fertilisation",
      "Harvesting":"Content for harvesting"
    },
    {
      "name":"Crop Name 2",
      "description":"Description of crop",
      "Sowing":"Content for Sowing",
      "Ideal Growth Conditions":"Content for growth Conditions",
      "Germination":"Content for germination",
      "Fertilisation":"Content for fertilisation",
      "Harvesting":"Content for harvesting"
    }
  ];

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
                  title: Text(crop['name']),
                  subtitle: Text(crop['description']),
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
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('${crop['name']} Details'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.orange),
        child: ListView.builder(
          itemCount: keys.length - 1,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Text(keys[index + 1].toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(crop[keys[index + 1]]),
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