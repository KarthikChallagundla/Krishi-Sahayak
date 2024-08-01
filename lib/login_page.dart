import 'package:demo_mvp/functions/auth_functions.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final _formkey = GlobalKey<FormState>();
  bool isLogin = false;
  bool showPassword = false;
  String email = '';
  String password = '';
  String username = '';
  String role = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/login.jpg',fit: BoxFit.cover,),
          Form(
            key: _formkey,
            child: Container(
              
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: (!isLogin) ? Colors.white : null,
                                ),
                                child: Text('Sign Up'),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    isLogin = true;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: (isLogin) ? Colors.white : null,
                                ),
                                child: Text('Login'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        (!isLogin) ? TextFormField(
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
                        ) : Container(),
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
                        (!isLogin) ? Row(
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
                        ) : Container(),
                        SizedBox(height: 10,),
                        Container(
                          width: 180,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if(_formkey.currentState!.validate()){
                                _formkey.currentState!.save();
                                String message;
                                if(isLogin){
                                  message = await signIn(email, password);
                                } else {
                                  message = await signUp(username, email, password, role);
                                }
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
                              isLogin ? 'Login' : 'Sign Up',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextButton(
                          onPressed: (){
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: isLogin ? Text("Don't have an account? SignUp") : Text("Already Signed Up? Login")
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