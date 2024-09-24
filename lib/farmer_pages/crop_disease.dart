import 'dart:io';

import 'package:demo_mvp/farmer_pages/about_disease.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CropDisease extends StatefulWidget {
  const CropDisease({super.key});

  @override
  State<CropDisease> createState() => _CropDiseaseState();
}

class _CropDiseaseState extends State<CropDisease> {

  String output = 'No image is uploaded';
  ImagePicker picker = ImagePicker();
  File? pickedImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Disease Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null){
                  setState(() {
                    isLoading = true;
                    pickedImage = File(image.path);
                  });
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    isLoading = false;
                    output = 'Apple Scab Disease';
                  });
                } else {
                  setState(() {
                    output = 'Please select an image';
                  });
                }
              },
              child: Text('Analyse the image'),
            ),
            (pickedImage == null) ? Container() : Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(image: FileImage(pickedImage!)),
              ),
            ),
            SizedBox(height: 15,),
            (isLoading) ? CircularProgressIndicator() : Text(output, style: TextStyle(fontSize: 16),),
            (output != 'Apple Scab Disease') ? Container() : TextButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutDisease()));
              },
              child: Text('Know more about disease'),
            ),
          ],
        ),
      ),
    );
  }
}