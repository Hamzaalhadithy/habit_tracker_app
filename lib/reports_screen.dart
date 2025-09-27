import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatefulWidget{
  const ReportsScreen({super.key});


  @override
  State<StatefulWidget> createState() {
    return ReportsScreenState();
  }
}

class ReportsScreenState extends State<ReportsScreen>{
 
  Map<String, List<int>> weeklyData = {};
  List<String> selectedHabits = [];
  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  void initState(){
    super.initState();
    loadweeklyDate();
  }

 Future<void> loadweeklyDate() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  selectedHabits = (Map<String, dynamic>.from(
    jsonDecode(prefs.getString('selectedHabitsMap')!)).keys.toList()
  ); 

  if(selectedHabits.isEmpty){
    setState(() {
      weeklyData = {};
    });
  return;
  }

  String? storeData = prefs.getString('weeklyData');
  if(storeData == null){
    Map<String, List<int>> mixedData = {
      for ( var habit in selectedHabits )
        habit : List.generate( 7 ,(_) => Random().nextBool() ? 1 : 0),
      };
      await prefs.setString('weeklyData', jsonEncode(mixedData));
      storeData = jsonEncode(mixedData);
      print(mixedData);
    }

    setState(() {
      Map<String, dynamic> decodedData = jsonDecode(storeData!);
      weeklyData = decodedData.map((key, value) => MapEntry(key, List<int>.from(value)));
    });
  }
 
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue.shade700,
      title: const Text(
        'Weekly Report',
        style: TextStyle(
          fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold
        ),
      ),
    ),
    body: weeklyData.isEmpty ? const Center(
      child: Text('No data available, Please configure habits first', style: TextStyle(fontSize: 16, color: Colors.grey),),
    ) : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(columns: buildColumns(), rows: buildrows())
      ),
    ),
   ); 
  }


  List<DataColumn> buildColumns(){
    return [
      const DataColumn(
        label: Text('Habit', style: TextStyle(fontWeight: FontWeight.bold),)
      ),
      ...daysOfWeek.map((day) 
        => DataColumn(
          label: Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              ),
          ),
        ),
      ),
    ];
  }

  List<DataRow> buildrows(){
    return selectedHabits.map((habit){
      return DataRow(
        cells: [
          DataCell(Text(habit)),
          ...List.generate(7, (index){
            bool isComp = weeklyData[habit]?[index] == 1;
            return DataCell(
              Icon(
                isComp ? Icons.check_circle : Icons.cancel,
                color: isComp ? Colors.green : Colors.red,
            ),
            );
          }),
        ]
      );
    }).toList();
  }
 }

