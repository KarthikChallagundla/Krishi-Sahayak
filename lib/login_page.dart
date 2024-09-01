import 'package:demo_mvp/details_page.dart';
import 'package:demo_mvp/functions/auth_functions.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final _formkey = GlobalKey<FormState>();
  bool showPassword = false;
  String email = '';
  String password = '';
  String username = '';
  String role = '';
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(91, 201, 36, 1)),
          ),
          Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 70,),
                    CircleAvatar(
                      child: Image.asset('assets/krishi_sahayak.png', scale: 3),
                      radius: 75,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          DefaultTabController(
                            length: 2,
                            child: TabBar(
                              onTap: (value) {
                                setState(() {
                                  selectedIndex = value;
                                });
                              },
                              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              unselectedLabelStyle: TextStyle(fontSize: 15),
                              tabs: [
                                Tab(text: "Create Account",),
                                Tab(text: "Log In",)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          (selectedIndex == 1) ? Column(
                            children: [
                              TextFormField(
                                key: ValueKey('email'),
                                decoration: InputDecoration(labelText: 'Enter email', border: OutlineInputBorder()),
                                validator: (value) {
                                  if(value.toString().contains('@') || value.toString().length > 10){
                                    return null;
                                  } else {
                                    return "Invalid Email/Phone number";
                                  }
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    email = newValue!;
                                  });
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                obscureText: !showPassword,
                                key: ValueKey('password'),
                                decoration: InputDecoration(
                                  labelText: 'Enter password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: showPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                  )
                                ),
                                validator: (value) {
                                  if(value.toString().length < 6){
                                    return "Password is weak";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    password = newValue!;
                                  });
                                },
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 180,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if(_formkey.currentState!.validate()){
                                      _formkey.currentState!.save();
                                      String message;
                                      message = await signIn(email, password);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                                          showCloseIcon: true,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(message),
                                        )
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Or signin with'),
                              SizedBox(height: 10,),
                            ],
                          ) : Column(
                            children: [
                              TextFormField(
                                key: ValueKey('email'),
                                decoration: InputDecoration(labelText: 'Enter email', border: OutlineInputBorder()),
                                validator: (value) {
                                  if(value.toString().contains('@') || value.toString().length > 10){
                                    return null;
                                  } else {
                                    return "Invalid Email";
                                  }
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    email = newValue!;
                                  });
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                obscureText: !showPassword,
                                key: ValueKey('password'),
                                decoration: InputDecoration(
                                  labelText: 'Enter password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: showPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                  )
                                ),
                                validator: (value) {
                                  if(value.toString().length < 6){
                                    return "Password is weak";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    password = newValue!;
                                  });
                                },
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Radio(
                                    value: "Farmer",
                                    groupValue: role,
                                    onChanged: (value){
                                      setState(() {
                                        role = "Farmer";
                                      });
                                    },
                                  ),
                                  Text('Farmer', style: TextStyle(fontSize: 20),),
                                  Radio(
                                    value: "User",
                                    groupValue: role,
                                    onChanged: (value){
                                      setState(() {
                                        role = "User";
                                      });
                                    },
                                  ),
                                  Text('User', style: TextStyle(fontSize: 20),),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 180,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(role == ''){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                                          content: Text('Please select a role!'),
                                          showCloseIcon: true,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 1),
                                        )
                                      );
                                    }
                                    else if(_formkey.currentState!.validate()){
                                      _formkey.currentState!.save();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsPage(email: email, password: password, role: role,)));
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                'Or sign up with'
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              showRoleSelectionDialog(context);
                            },
                            child: signInButton('http://pngimg.com/uploads/google/google_PNG19635.png', 'Continue with Google'),
                          ),
                          // SizedBox(height: 10,),
                          // signInButton('https://static.vecteezy.com/system/resources/previews/006/795/445/non_2x/smartphone-icon-cellphone-mobile-phone-sign-symbol-vector.jpg', 'Continue with Mobile')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget signInButton(String imgUrl, String name) {
    return SizedBox(
      height: 50,
      width: 250,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   child: Image.network(                      
            //     imgUrl,
            //     fit: BoxFit.fitWidth,
            //   ),
            // ),
            // SizedBox(width: 5.0,),
            Text(name),
          ],
        ),
      ),
    );
  }

  void showRoleSelectionDialog(BuildContext context) {
    String role = "";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Choose a role'),
              content: Row(
                children: [
                  Radio(
                    value: "Farmer",
                    groupValue: role,
                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                  ),
                  Text('Farmer', style: TextStyle(fontSize: 20),),
                  Radio(
                    value: "User",
                    groupValue: role,
                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                  ),
                  Text('User', style: TextStyle(fontSize: 20),),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    role = ""; // Reset role
                    Navigator.of(context).pop();
                  },
                  child: Text('No', style: TextStyle(color: Colors.red),),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close dialog
                    String message = await signInWithGoogle(role);
                    
                    // Display feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ),
                    );

                    setState(() {}); // Optional: Refresh state
                  },
                  child: Text('Yes', style: TextStyle(color: Colors.blue),),
                ),
              ],
            );
          },
        );
      },
    );
  }
}