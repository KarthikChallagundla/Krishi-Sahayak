import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CropDoctor extends StatefulWidget {
  const CropDoctor({super.key});

  @override
  State<CropDoctor> createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      style: TextStyle(fontSize: 16),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(hintText: 'Enter your problem', border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(shape: CircleBorder()),
                  child: Icon(Icons.arrow_upward),
                )
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}