import 'dart:convert';
import 'dart:io';

import 'package:demo_mvp/database/crop_disease_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse('http://wavowov.pythonanywhere.com/predict'),
                  );

                  request.files.add(await http.MultipartFile.fromPath('file', image.path));

                  var response = await request.send();

                  if (response.statusCode == 200) {
                    var responseData = await http.Response.fromStream(response);
                    var jsonResponse = json.decode(responseData.body);
                    setState(() {
                      isLoading = false;
                      output =
                          "${diseases[jsonResponse['predicted_index']]}";
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                      output = "Error: ${response.statusCode}";
                    });
                  }
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
          ],
        ),
      ),
    );
  }
}