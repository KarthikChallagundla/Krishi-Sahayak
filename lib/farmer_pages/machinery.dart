import 'package:flutter/material.dart';

class MachineryTools extends StatefulWidget {
  const MachineryTools({super.key});

  @override
  State<MachineryTools> createState() => _MachineryToolsState();
}

class _MachineryToolsState extends State<MachineryTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(),
              child: Card(
                child: Row(
                  children: [
                    Image.asset('assets/plough.jpeg'),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Plough', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text('Manufactured by : A&B Company'),
                        Text('Price : 100/hr'),
                        Text('Description : This tool is for rent'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 100,
              decoration: BoxDecoration(),
              child: Card(
                child: Row(
                  children: [
                    Image.asset('assets/sprayer.jpeg'),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sprayer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text('Manufactured by : A&B Company'),
                        Text('Price : 100/hr'),
                        Text('Description : This tool is for rent'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}