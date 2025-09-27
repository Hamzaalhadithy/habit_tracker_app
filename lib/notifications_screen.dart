import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedHabits = [];
  List<String> selectedTimes = [];
  Map<String, String> allHabitMap = {};

  @override
  void initState() {
    super.initState();
    loadDate();
  }

  Future<void> loadDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      allHabitMap = Map<String, String>.from(
        jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'),
      );
      selectedHabits = prefs.getStringList('notificationHabits') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
    });
  }

  Future<void> saveNotifiSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationHabits', selectedHabits);
    await prefs.setStringList('notificationTimes', selectedTimes);
  }

  void sendNotification() {
    if (html.Notification.permission != "granted") {
      html.Notification.requestPermission().then((permission) {
        if (permission == "granted") {
          html.Notification(
            'Habit Reminder',
            body: "It's time to work on your habits!",
          );
          print('Notification permission granted');
        } else {
          print('Notification permission denied');
        }
      });
    } else {
      html.Notification(
        'Habit Reminder',
        body: "It's time to work on your habits!",
      );
      print("Notification is sent directly");
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value){
                setState(() {
                  notificationsEnabled = value;
                });
                saveNotifiSettings();
              },
            ),
            Divider(),
            Text("Select habits for Notifications", style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Wrap(
              spacing: 8.0,
              runSpacing: 8,
              children: allHabitMap.entries.map((entry){
                final habit = entry.key;
                final colorHex = entry.value;
                final color = _getColorFromHex(colorHex);
                return FilterChip(
                  label: Text(habit),
                  labelStyle: TextStyle(color: color),
                  selected: selectedHabits.contains(habit),
                  selectedColor: color.withOpacity(0.3),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: color, width: 2,),
                  onSelected: (bool selected){
                    setState(() {
                      if(selected){
                        selectedHabits.add(habit);
                      }else{
                        selectedHabits.remove(habit);
                      }
                    });
                    saveNotifiSettings();
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            Text("Selecte Times for Notification"),
            SizedBox(height: 20,),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Morning', 'Afternoon', 'Evening'].map((time){
                return FilterChip(
                  label: Text(time),
                  onSelected: (bool selected){
                    setState(() {
                      if(selected){
                        selectedTimes.add(time);
                      }else{
                        selectedTimes.remove(time);
                      }
                    });
                    saveNotifiSettings();
                  },
                  selected: selectedTimes.contains(time),
                  );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: (){
                sendNotification();
              },
              child: Text('Send Test Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12,)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
