import 'dart:convert';
import 'dart:io';

import 'package:demo_mvp/database/crop_disease_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // For stylish fonts

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
    // Get screen dimensions to adjust content responsively
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crop Disease Detector',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image selection button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,  // Adjust button width relative to screen
                  vertical: screenHeight * 0.02,
                ),
              ),
              icon: Icon(Icons.photo, size: 24),
              label: Text(
                'Select and Analyse Image',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,  // Text size scales with screen width
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    isLoading = true;
                    pickedImage = File(image.path);
                  });
                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse('http://wavowov.pythonanywhere.com/predict'),
                  );

                  request.files
                      .add(await http.MultipartFile.fromPath('file', image.path));

                  var response = await request.send();

                  if (response.statusCode == 200) {
                    var responseData = await http.Response.fromStream(response);
                    var jsonResponse = json.decode(responseData.body);
                    setState(() {
                      isLoading = false;
                      output =
                          "Predicted Disease: ${diseases[jsonResponse['predicted_index']]}";
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
            ),
            SizedBox(height: screenHeight * 0.03), // Height relative to screen size

            // Display selected image
            (pickedImage == null)
                ? Container(
                    height: isLandscape ? screenHeight * 0.25 : screenHeight * 0.2,
                    width: isLandscape ? screenWidth * 0.35 : screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade400, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.green.shade400,
                        size: screenWidth * 0.15,
                      ),
                    ),
                  )
                : AnimatedContainer(
                    duration: Duration(seconds: 1),
                    height: isLandscape ? screenHeight * 0.35 : screenHeight * 0.3,
                    width: isLandscape ? screenWidth * 0.45 : screenWidth * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(pickedImage!),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: screenHeight * 0.03),

            // Display loading or result
            (isLoading)
                ? CircularProgressIndicator(
                    color: Colors.green.shade700,
                  )
                : Text(
                    output,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,  // Text size scales with screen width
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
