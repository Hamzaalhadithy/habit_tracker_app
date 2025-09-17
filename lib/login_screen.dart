import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen>{
  final _emailCont = TextEditingController();
  final _passwordCont = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //default credinationals
  final String defaultUsername = "testuser@gmail.com";
  final String defaultPasword = "password123";

  void _login() async {
    try{
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailCont.text,
        password: _passwordCont.text,
      );
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found'){
        Fluttertoast.showToast(msg: 'No user found for this email');
      }
      else if (e.code == 'wrong-password'){
        Fluttertoast.showToast(msg: 'Wrong password');
      }
      else{
        Fluttertoast.showToast(msg: e.code.toString(), gravity: ToastGravity.BOTTOM, backgroundColor: Colors.blue.shade700, webPosition: 'center' );
      }
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Habitt',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _emailCont,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.blue.shade700,),
                      hintText: 'Enter Username',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordCont,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password, color: Colors.blue.shade700,),
                      hintText: 'Enter Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){
                      // password logic
                    },
                    child: const Text('Forget Password?', style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'or',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: (){
                    // navigate to register screen
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 70, vertical: 15,
                    )
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}