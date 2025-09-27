import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker_app/country_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit_tracker_screen.dart';

class PersonalInfoScreen extends StatefulWidget{
  const PersonalInfoScreen({super.key});

  @override
  personalInfoScreen createState() => personalInfoScreen();
}

class personalInfoScreen extends State<PersonalInfoScreen>{
  final nameCont = TextEditingController();
  final usernameCont = TextEditingController();
  double age = 25;
  String country = 'Iraq';
  List<String> _countries= [];

  @override
  void initState(){
    super.initState();
    loadCountries().then((_){
      loadUserDate();
    });
  }

  Future<void> loadCountries() async {
    try{
      List<String> countries = await fetchCountries();
      setState((){
        _countries = countries; 
      });
    }catch(e){
      _showToast('Error fetching countries');
    }
  }

  Future<void> loadUserDate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nameCont.text = prefs.getString('name')!;
      usernameCont.text = prefs.getString('username')!;
      age = prefs.getDouble('age')! ?? 25;
      country = prefs.getString('country') ?? 'Iraq';
    });
  }

  Future<void> saveUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', nameCont.text);
    await prefs.setString('username', usernameCont.text);
    await prefs.setDouble('age', age);
    await prefs.setString('country', country);

    _showToast('Profile updates Sucessfully');

    Navigator.pop(context, nameCont.text);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text('Personal Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 42,),
            buildTextField(cont: nameCont, label: 'Name', icon: Icons.person,),
            const SizedBox(height: 16,),
            buildTextField(cont: usernameCont, label: 'Username', icon: Icons.alternate_email,),
            const SizedBox(height: 16,),
            Text(
              'Age ${age.round()}',
              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: age,
              min: 21,
              max: 100,
              divisions: 79,
              activeColor: Colors.blue.shade700,
              inactiveColor: Colors.blue.shade300,
              onChanged: (value){
                setState(() {
                  age = value;
                });
              },
            ),
            const SizedBox(height: 16,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade700),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: country,
                isExpanded: true,
                underline: const SizedBox(),
                items: _countries.map((String value){
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue){
                  setState(() {
                    country = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24,),
            ElevatedButton(
              onPressed: saveUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                elevation: 5,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTextField({required TextEditingController cont, required String label, required IconData icon}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade700),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700,),
          labelText: label,
          border: InputBorder.none 
        ),
      ),
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
}



