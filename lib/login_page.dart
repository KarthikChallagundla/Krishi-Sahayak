import 'package:demo_mvp/functions/auth_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String role = '';
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600; // Assuming mobile devices have a width less than 600

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
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : screenSize.width * 0.25), // Responsive padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.1), // Responsive top spacing
                    CircleAvatar(
                      child: Image.asset('assets/krishi_sahayak.png', scale: 3),
                      radius: 75,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), 
                        color: Colors.white,
                      ),
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
                                Tab(text: "Create Account"),
                                Tab(text: "Log In"),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          (selectedIndex == 1) 
                          ? Column(
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
                              SizedBox(height: 10),
                              TextFormField(
                                obscureText: !showPassword,
                                key: ValueKey('password'),
                                decoration: InputDecoration(
                                  labelText: 'Enter password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
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
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          TextEditingController emailController = TextEditingController();
                                          return AlertDialog(
                                            title: Text('Enter your email'),
                                            content: TextField(
                                              controller: emailController,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Reset link sent"),
                                                      behavior: SnackBarBehavior.floating,
                                                      showCloseIcon: true,
                                                    )
                                                  );
                                                },
                                                child: Text('Send reset link'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Forgot Password?'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
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
                              SizedBox(height: 10),
                              Text('Or sign in with'),
                              SizedBox(height: 10),
                            ],
                          ) 
                          : Column(
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
                              SizedBox(height: 10),
                              TextFormField(
                                obscureText: !showPassword,
                                key: ValueKey('password'),
                                decoration: InputDecoration(
                                  labelText: 'Enter password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
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
                              SizedBox(height: 10),
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
                                  Text('Farmer', style: TextStyle(fontSize: 20)),
                                  Radio(
                                    value: "User",
                                    groupValue: role,
                                    onChanged: (value){
                                      setState(() {
                                        role = "User";
                                      });
                                    },
                                  ),
                                  Text('User', style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              SizedBox(height: 10),
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
                                      signUp('Guest', email, password, role);
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Or sign up with'),
                              SizedBox(height: 10),
                            ],
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              await signInWithGoogle();
                            },
                            child: signInButton('assets/google.png', 'Continue with Google'),
                          ),
                          SizedBox(height: 10),
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
      width: 300,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Image.asset(imgUrl),
            ),
            SizedBox(width: 10),
            Text(name, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
