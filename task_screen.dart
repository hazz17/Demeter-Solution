import 'package:flutter/material.dart';
import 'profile_screen.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, dynamic>> tasks = [
    {'name': 'Water The Crops', 'date': 'March 28, 2025', 'status': 'done'},
    {'name': 'Pest Control', 'date': 'March 28, 2025', 'status': 'pending'},
  ];

  String _userName = "";
  String? _profileImage;

  void _toggleTaskStatus(int index) {
    setState(() {
      tasks[index]['status'] = tasks[index]['status'] == 'done' ? 'pending' : 'done';
    });
  }

  void _addTask() async {
    TextEditingController taskController = TextEditingController();
    DateTime? pickedDate;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Add New Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Task Name",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.green[700],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    setState(() {
                      pickedDate = date;
                    });
                  }
                },
                child: Text(
                  pickedDate == null ? "Pick Date" : "${pickedDate!.toLocal()}".split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty && pickedDate != null) {
                  setState(() {
                    tasks.add({
                      'name': taskController.text,
                      'date': "${pickedDate!.toLocal()}".split(' ')[0],
                      'status': 'pending',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5E9E8D),
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TASK",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                Row(
                  children: [
                    Text(_userName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                    SizedBox(width: 10),
                    GestureDetector( // <-- Wrap with GestureDetector
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()), // Navigate to ProfileScreen
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 30,
                        backgroundImage: _profileImage != null
                            ? NetworkImage(_profileImage!)
                            : AssetImage("assets/default_avatar.png") as ImageProvider,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(tasks[index]['name'], style: TextStyle(color: Colors.white)),
                      subtitle: Text(tasks[index]['date'], style: TextStyle(color: Colors.white70)),
                      trailing: SizedBox(
                        width: 32,
                        child: IconButton(
                          icon: Icon(
                            tasks[index]['status'] == 'done'
                                ? Icons.check_circle
                                : Icons.pending_actions,
                            color: tasks[index]['status'] == 'done'
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                          ),
                          onPressed: () => _toggleTaskStatus(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: _addTask,
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
