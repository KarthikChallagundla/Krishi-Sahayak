import 'package:flutter/material.dart';

class AboutDisease extends StatefulWidget {
  const AboutDisease({super.key});

  @override
  State<AboutDisease> createState() => _AboutDiseaseState();
}

class _AboutDiseaseState extends State<AboutDisease> {

  Map<String, dynamic> appleScab = {
    "disease": "Apple Scab",
    "causing_agent": "Venturia inaequalis",
    "affected_parts": "leaves, fruit",
    "symptoms": "Dark, sunken lesions on leaves and fruit; Leaf curling; Misshapen fruit",
    "conditions_favoring_disease": "Cool, wet conditions",
    "management": "Remove infected parts; Use fungicides; Improve air circulation"
  };


  @override
  Widget build(BuildContext context) {

    List<String> keys = appleScab.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Apple Scab disease'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemCount: keys.length - 1,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(keys[index + 1].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text(appleScab[keys[index + 1]],),
                SizedBox(height: 10,)
              ],
            );
          },
        ),
      ),
    );
  }
}