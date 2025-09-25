import "package:flutter/material.dart";

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
    name = widget.username; 
  }

  Future<void> _saveHabits() async{
    // save habits on the device later
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
        onPressed: (){},
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Add Habits',
        child: const Icon(Icons.add),
      ) : null
    );

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