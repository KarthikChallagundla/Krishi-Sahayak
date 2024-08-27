import 'package:demo_mvp/functions/auth_functions.dart';
import 'package:demo_mvp/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  
  final _formkey = GlobalKey<FormState>();
  bool showPassword = false;
  String email = '';
  String password = '';
  String username = '';
  String role = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                color: Colors.orange[400],
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.white,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                color: Colors.green[400],
              ),
            ],
          ),
          Form(
            key: _formkey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Image.asset('assets/krishi_sahayak.png', scale: 3),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.circular(10), color: Colors.white),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2 - 35,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: (){},
                                child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2 - 35,
                              child: TextButton(
                                onPressed: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                                },
                                child: Text('Login'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          key: ValueKey('username'),
                          decoration: InputDecoration(labelText: 'Enter Username', border: OutlineInputBorder()),
                          validator: (value) {
                            if(value.toString().length <3){
                              return "Username is so small";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            setState(() {
                              username = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 10,),
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
                            onPressed: () async {
                              if(_formkey.currentState!.validate()){
                                _formkey.currentState!.save();
                                String message;
                                message = await signUp(username, email, password, role);

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
                              'Sign Up',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.black, fontSize: 16)),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));}
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}