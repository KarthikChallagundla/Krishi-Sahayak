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
                        DefaultTabController(
                          length: 2,
                          child: TabBar(
                            onTap: (value) {
                              setState(() {
                                selectedIndex = value;
                              });
                            },
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
                            SizedBox(height: 10,),
                            Text(
                              'Or sign up with'
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        signInButton('http://pngimg.com/uploads/google/google_PNG19635.png', 'Continue with Google', signInWithGoogle),
                        SizedBox(height: 10,),
                        signInButton('https://pngimg.com/uploads/facebook_logos/facebook_logos_PNG19753.png', 'Continue with Facebook', signInWithFacebook),
                        // SizedBox(height: 10,),
                        // signInButton('https://static.vecteezy.com/system/resources/previews/006/795/445/non_2x/smartphone-icon-cellphone-mobile-phone-sign-symbol-vector.jpg', 'Continue with Mobile')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  signInButton(String imgUrl, String name, void Function()? fun) {
    return SizedBox(
      height: 50,
      width: 250,
      child: GestureDetector(
        onTap: fun,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children:[
              Container(
                child: Image.network(                      
                  imgUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(width: 5.0,),
              Text(name),
            ],
          ),
        ),
      ), 
    );
  }
}