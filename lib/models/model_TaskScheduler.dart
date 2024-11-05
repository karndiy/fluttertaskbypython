// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart'; // For platform channels

// class TaskScheduler {
//   static const platform = MethodChannel('com.example.task_scheduler'); // Define a channel name

//   DateTime? sleepTime;
//   DateTime? restartTime;

//   void setSleepTime(DateTime time) {
//     sleepTime = time;
//     _scheduleTask("sleep", time);
//   }

//   void setRestartTime(DateTime time) {
//     restartTime = time;
//     _scheduleTask("restart", time);
//   }

//   void _scheduleTask(String taskType, DateTime time) {
//     String formattedTime = DateFormat("HH:mm").format(time);
//     print("Scheduled $taskType task at $formattedTime.");

//     // Send the task to native code
//     _scheduleWindowsTask(taskType, time);
//   }

//   Future<void> _scheduleWindowsTask(String taskType, DateTime time) async {
//     try {
//       await platform.invokeMethod('scheduleTask', {
//         'taskType': taskType,
//         'time': DateFormat("HH:mm").format(time)
//       });
//     } on PlatformException catch (e) {
//       print("Failed to schedule task: '${e.message}'.");
//     }
//   }

//   void cancelTasks() {
//     sleepTime = null;
//     restartTime = null;
//     print("Canceled all scheduled tasks.");
//     platform.invokeMethod('cancelTasks');
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // For platform channels
import 'package:process_run/process_run.dart';
import 'dart:io';


class TaskScheduler {
  static const platform = MethodChannel('com.example.task_scheduler');

  DateTime? sleepTime;
  DateTime? restartTime;

  Future<void> runPythonScript() async {
    try {
      // Adjust this path if you placed your script in a different folder
      final result = await run('python', ['C:\\projects\\appdev\\scripts\\app.py']);
      print('test ok');
      print('Python script output: ${result.stdout}');
      print('Errors: ${result.stderr}');
    } catch (e) {
      print('Error running Python script: $e');
    }
  }

  void setSleepTime(DateTime time) {
    sleepTime = time;
    _scheduleTask("sleep", time);
  }

  void setRestartTime(DateTime time) {
    restartTime = time;
    _scheduleTask("restart", time);
  }

  void _scheduleTask(String taskType, DateTime time) {
    String formattedTime = DateFormat("HH:mm").format(time);
    print("Scheduled $taskType task at $formattedTime.");
    _scheduleWindowsTask(taskType, time);
  }

  Future<void> _scheduleWindowsTask(String taskType, DateTime time) async {
    try {
      await platform.invokeMethod('scheduleTask', {
        'taskType': taskType,
        'time': DateFormat("HH:mm").format(time),
      });
    } on PlatformException catch (e) {
      print("Failed to schedule task: '${e.message}'.");
    }
  }

  void cancelTasks() {
    sleepTime = null;
    restartTime = null;
    print("Canceled all scheduled tasks.");
    platform.invokeMethod('cancelTasks');
  }
}

