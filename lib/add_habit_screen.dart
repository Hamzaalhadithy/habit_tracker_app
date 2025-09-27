import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHabitScreen extends StatefulWidget{
  const AddHabitScreen({super.key});

  @override
  _addHabitScreenState createState() => _addHabitScreenState();
}

class _addHabitScreenState extends State<AddHabitScreen>{
  final TextEditingController habitCont = TextEditingController();
  Color selectedColor = Colors.amber;
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  final Map<String, Color> habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };
  String selectedColorName = 'Amber';

  @override
  void initState(){
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedHabitsMap = Map<String, String>.from(
        jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}' )
      );
      completedHabitsMap = Map<String, String>.from(
        jsonDecode(prefs.getString('completedHabitsMap') ?? '{}' )
      );
    });
  }
  Future<void> saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedHabitsMap', jsonEncode(selectedHabitsMap));
    await prefs.setString('completedHabitsMap', jsonEncode(completedHabitsMap));
  }

  @override
  Widget build(BuildContext context){
    Map<String, String> allHabitsMap = {...selectedHabitsMap, ...completedHabitsMap};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Configure Habits'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: habitCont,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              'Select Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: selectedColorName,
                isExpanded: true,
                underline: const SizedBox(),
                items: habitColors.keys.map((String colorName){
                  return DropdownMenuItem<String>(
                    value: colorName,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: habitColors[colorName],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        colorName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    selectedColorName = newValue!;
                    selectedColor = habitColors[selectedColorName]!;
                  });
                  saveHabits();
                },
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                if (habitCont.text.isNotEmpty){
                  setState(() {
                    selectedHabitsMap[habitCont.text] = selectedColor.value.toRadixString(16);
                    habitCont.clear();
                    selectedColorName = 'Amber';
                    selectedColor = habitColors[selectedColorName]!;

                  });
                  saveHabits();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Add Habit',
                style: TextStyle(
                  color: Colors.white, fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: ListView(
                children: allHabitsMap.entries.map((entry){
                  final habitName = entry.key;
                  final habitColor = _getColorFromHex(entry.value);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: habitColor,
                    ),
                    title: Text(habitName),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red,),
                      onPressed: (){
                        setState(() {
                          selectedHabitsMap.remove(habitName);
                          completedHabitsMap.remove(habitName);
                        });
                        saveHabits();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }
}