import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tools').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            } else {
              final prodList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: prodList.length,
                itemBuilder: (context, index) {
                  var product = prodList[index];
                  return Container(
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
                              Text(product['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              Text(product['description']),
                              Text(product['price']),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}