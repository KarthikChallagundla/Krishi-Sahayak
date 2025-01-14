import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_mvp/farmer_pages/sell_tools.dart';
import 'package:demo_mvp/functions/database_functions.dart';
import 'package:flutter/material.dart';

class MyTools extends StatefulWidget {
  final String user;
  const MyTools({super.key, required this.user});

  @override
  State<MyTools> createState() => _MyToolsState();
}

class _MyToolsState extends State<MyTools> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String prodName = '';
  String prodPrice = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tools'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tools').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            } else {
              final prodList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: prodList.length,
                itemBuilder: (context, index) {
                  return (prodList[index]['owner'] != widget.user) ? Container() : Card(
                    child: ListTile(
                      leading: SizedBox(width: 50, child: Image.network(prodList[index]['imageUrl'])),
                      title: Text("Name : ${prodList[index]['name']}"),
                      subtitle: Text("Description : ${prodList[index]['description']}\nPrice : ${prodList[index]['price']}"),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(  
                              value: 1,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      backgroundColor: Color.fromRGBO(232, 255, 245, 0.9),
                                      title: Text('Update Price of ${prodList[index]['name']}'),
                                      content: Form(
                                        key: _formkey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                keyboardType: TextInputType.number,
                                                key: ValueKey('prodPrice'),
                                                decoration: InputDecoration(
                                                  hintText: 'Product price',
                                                  border: OutlineInputBorder(),
                                                  fillColor: Color.fromRGBO(128, 128, 128, 0.3),
                                                  filled: true,
                                                ),
                                                initialValue: prodList[index]['price'],
                                                validator: (value) {
                                                  if(value!.isEmpty){
                                                    return "This field is empty";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onSaved: (newValue) {
                                                  setState(() {
                                                    prodPrice = newValue!;
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    if(_formkey.currentState!.validate()){
                                                      _formkey.currentState!.save();
                                                      updateProduct('tools', prodList[index]['name'], 'price', prodPrice);
                                                      setState(() {
                                                        _formkey = GlobalKey<FormState>();
                                                      });
                                                    }
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Successfully edited'),
                                                      )
                                                    );
                                                  },
                                                  child: const Text("Edit product"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                );
                              },
                              child: Row(  
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 10,),
                                  Text("Edit")
                                ],
                              ),
                            ),
                            PopupMenuItem(  
                              value: 2,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Remove Product?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteProduct('products', prodList[index]['id']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(  
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10,),
                                  Text("Delete")
                                ],
                              ),
                            )
                          ];
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 32, right: 8),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SellTools(user: widget.user,)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}