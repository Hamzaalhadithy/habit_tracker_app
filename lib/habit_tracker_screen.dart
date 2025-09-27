import "dart:convert";

import "package:flutter/material.dart";
import "package:habit_tracker_app/add_habit_screen.dart";
import "package:habit_tracker_app/login_screen.dart";
import "package:habit_tracker_app/personal_info_screen.dart";
import "package:habit_tracker_app/reports_screen.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'notifications_screen.dart';
class HabitTrackerScreen extends StatefulWidget{
  final String username;

  const HabitTrackerScreen({super.key, required this.username});

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen>{
  Map<String, String> selectedHabitsMap = {}; // <name, color> kinda 
  Map<String, String> completedHabitsMap = {};
  String name = '';

  @override
  void initState(){
    super.initState();
    _loadUserData();
    }

  Future<void> _saveHabits() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedHabitsMap', jsonEncode(selectedHabitsMap));
    await prefs.setString('completedHabitsMap', jsonEncode(completedHabitsMap));
  }

  Future<void> _loadUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? widget.username;
      selectedHabitsMap = Map<String, String>.from(
        jsonDecode(prefs.getString('selectedHabitsMap')?? '{}')
      );
      completedHabitsMap = Map<String, String>.from(
        jsonDecode(prefs.getString('completedHabitsMap')?? '{}')
      );
    });
  }

  Color _getColorFromHex(String hexColor){
    hexColor = hexColor.replaceAll('#', '');
    if(hexColor.length == 6){
      hexColor = 'FF$hexColor'; // add opacity to the color
    }
    return Color(int.parse('0x$hexColor'));
  }

  // ignore: unused_element
  Color _getHabitcolor(String habit, Map<String, String> habitMap){
    String? colorHex = habitMap[habit];
    if(colorHex != null){
      try {
        return _getColorFromHex(colorHex);
      } catch(e){
        print("Error parsing color of $habit: $e");
      }
    }
    return Colors.blue; 
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          name.isNotEmpty ? name : 'Loading...',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configure'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddHabitScreen()),
                ).then((updatedHabit){
                  _loadUserData();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Personal Info'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoScreen(),)
                ).then((_){
                  _loadUserData();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Reports'),
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => ReportsScreen()
                  ),
                );
              }
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationsScreen())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: (){
                signOut(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'To do 📝',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selectedHabitsMap.isEmpty ? const Expanded(
            child: Center(
              child: Text('Use the + button to create a new habit',
                style: TextStyle(
                  fontSize: 18, color: Colors.grey,
                ),
              ),
            ),
          ) : Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: selectedHabitsMap.length,
              itemBuilder: (context, index){
                String habit = selectedHabitsMap.keys.elementAt(index);
                Color habitColor = _getHabitcolor(habit, selectedHabitsMap);
                return Dismissible(
                  key: Key(habit),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction){
                    setState(() {
                      String color = selectedHabitsMap.remove(habit)!; // remove returns the value assosicated with the key
                      completedHabitsMap[habit] = color;
                      _saveHabits();
                    });
                  },
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Swipe to Complete',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  ),
                  child: _buildHabitCard(habit, habitColor),
                );
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Done ✅🎉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          completedHabitsMap.isEmpty 
            ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Swipe right on an activity to mark as done',
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            )
            : Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: completedHabitsMap.length,
                itemBuilder: (context, index){
                  String habit = completedHabitsMap.keys.elementAt(index);
                  Color habitColor = _getHabitcolor(habit, completedHabitsMap);
                  return Dismissible(
                    key: Key(habit),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        String color = completedHabitsMap.remove(habit)!;
                        selectedHabitsMap[habit] = color;
                        _saveHabits();
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        children: [
                          Icon(Icons.undo, color: Colors.white),
                          SizedBox(width: 10,),
                          Text(
                            'Swipe to undo',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: _buildHabitCard(habit, habitColor, isComp: true),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: selectedHabitsMap.isEmpty ? FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
        },
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Add Habits',
        child: const Icon(Icons.add),
      ) : null
    );

  }

  void signOut(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
  }
  Widget _buildHabitCard(String title, Color color, {bool isComp = false}){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: Container(
        height: 60,
        child: ListTile(
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: isComp ? const Icon(Icons.check_circle, color: Colors.green, size: 28) : null,
        ),
      ),
    );
  }
  
}