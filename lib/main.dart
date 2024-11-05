import 'package:flutter/material.dart';
import '../models/model_TaskScheduler.dart';
import 'package:process_run/process_run.dart'; // Import for running the Python script
import 'dart:io';

void main() {
  runApp(TaskSchedulerApp());
}

class TaskSchedulerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Scheduler App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SchedulerScreen(),
    );
  }
}

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  final TaskScheduler taskScheduler = TaskScheduler();

  TimeOfDay? _sleepTime;
  TimeOfDay? _restartTime;

  Future<void> _selectTime(BuildContext context, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (type == "sleep") {
          _sleepTime = picked;
          DateTime sleepDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            picked.hour,
            picked.minute,
          );
          taskScheduler.setSleepTime(sleepDateTime);
        } else if (type == "restart") {
          _restartTime = picked;
          DateTime restartDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            picked.hour,
            picked.minute,
          );
          taskScheduler.setRestartTime(restartDateTime);
        }
      });
    }
  }

  // Function to run the Python script
  Future<void> runPythonScript() async {
    try {
      // Arguments to be passed to the script
      final arguments = ['10', '20', '30']; // Example numbers to calculate average
      final scriptPath = '${Directory.current.path}\\scripts\\app2.py';
      print(scriptPath);
     // final result = await run('python', ['../scripts/app.py']); // Update with your script name
     final result = await run('python', [scriptPath,...arguments]); // Update with your script name
      print('Python script output: ${result.stdout}');
    } catch (e) {
      print('Error running Python script: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Scheduler'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Set Sleep Time'),
              subtitle: Text(_sleepTime == null
                  ? "Not set"
                  : _sleepTime!.format(context)),
              trailing: IconButton(
                icon: Icon(Icons.alarm),
                onPressed: () => _selectTime(context, "sleep"),
              ),
            ),
            ListTile(
              title: Text('Set Restart Time'),
              subtitle: Text(_restartTime == null
                  ? "Not set"
                  : _restartTime!.format(context)),
              trailing: IconButton(
                icon: Icon(Icons.alarm),
                onPressed: () => _selectTime(context, "restart"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                taskScheduler.cancelTasks();
                setState(() {
                  _sleepTime = null;
                  _restartTime = null;
                });
              },
              child: Text('Cancel Scheduled Tasks'),
            ),
            SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: runPythonScript, // Call the runPythonScript on button press
              child: Text('Run Python Script'),
            ),
          ],
        ),
      ),
    );
  }
}
