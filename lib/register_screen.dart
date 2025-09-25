import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker_app/habit_tracker_screen.dart';
import 'dart:async';
import 'login_screen.dart';

class registerScreen extends StatefulWidget{
  const registerScreen({super.key});

  @override 
  _registerScreenState createState() => _registerScreenState();

}

class _registerScreenState extends State<registerScreen>{
  final _nameCont = TextEditingController();
  final _usernameCont = TextEditingController();
  double _age = 25;
  String _country = 'Iraq';
  List<String> _countries = [];
  List<String> selectedHabits = [];
  List<String> availableHabits = [
    'Wake Up Early',
    'Workout',
    'Drink Water',
    'Meditate',
    'Read a Book',
    'Practice Gratitude',
    'Sleep 8 Hours',
    'Eat Healthy',
    'Journal',
    'Walk 10,000 Steps'
  ];

  @override
  void initState(){
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async{
    List<String> subsetCountries = [
      'Iraq'
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'India',
      'Germany',
      'France',
      'Japan',
      'China',
      'Brazil',
      'South Africa',
      'Iraq'
    ];

    setState(() {
      _countries = subsetCountries;
      _countries.sort();
      _country = _countries.isNotEmpty ? _countries[0] : 'Iraq';
    });

  }

  void _register() async{
    final name = _nameCont.text;
    final username = _usernameCont.text;

    if(username.isEmpty || name.isEmpty){
      _showToast('Please filll in all fields');
      return;
    }

    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => HabitTrackerScreen(username: username))
    );
  }

  void _showToast(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16,
    );
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildInputField(_nameCont, 'Name', Icons.person),
                const SizedBox(height: 10,),
                buildInputField(_usernameCont, 'Username', Icons.alternate_email),
                const SizedBox(height: 10,),
                Text('Age ${_age.round()}', style: TextStyle(color: Colors.white, fontSize: 18),),
                Slider(
                  value: _age,
                  min: 21,
                  max: 100,
                  divisions: 79,
                  activeColor: Colors.blue.shade600,
                  inactiveColor: Colors.blue.shade300,
                  onChanged: (value){
                    setState(() {
                      _age = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                buildContryDropDown(),
                const SizedBox(
                  height: 10,
                ),
                const Text('Select Your Habits', style: TextStyle(color: Colors.white, fontSize: 18),),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableHabits.map((habit){
                    final isSelected = selectedHabits.contains(habit);
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          if(isSelected){
                            selectedHabits.removeWhere((item) => item == habit);
                          }
                          if(!isSelected){
                            selectedHabits.add(habit);
                          }
                          
                        });

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.shade600 : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.blue.shade700),
                        ),
                        child: Text(
                          habit,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ); 
                  }).toList(),
                ),
                const SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20,
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(TextEditingController cont, String hint, IconData icon){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade600),
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 15,
          )
        ),
      ),
    );
  }

  Widget buildContryDropDown(){
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: _country,
        icon: Icon(Icons.arrow_downward, color: Colors.white,),
        isExpanded: true,
        underline: const SizedBox(),
        items: _countries.map( (String value){
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newvalue){
          setState(() {
            _country = newvalue!;
          });
        },
      ),
    );
  }


}