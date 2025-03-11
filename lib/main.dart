import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import './task_bloc.dart';
import './task_event.dart';
import './task_state.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<String> notStartedTasks = ["مطالعه کتاب", "ورزش"];
  List<String> inProgressTasks = ["یادگیری فلاتر"];
  List<String> doneTasks = ["انجام تکالیف"];

  TextEditingController _taskController = TextEditingController();

  // متد برای اضافه کردن تسک جدید
  void _addTask() {
    String task = _taskController.text.trim();
    if (task.isNotEmpty && !notStartedTasks.contains(task)) {
      setState(() {
        notStartedTasks.add(task);
        _taskController.clear();
      });
    }
  }

  
  // متد برای حذف تسک
void _removeTask(String task, List<String> taskList) {
  setState(() {
    // بررسی کنید که تسک در لیست وجود دارد
    if (taskList.contains(task)) {
      taskList.remove(task);
    }
  });
}


  Widget _buildTaskColumn(String title, List<String> tasks, List<String> otherTasks1, List<String> otherTasks2, Color color) {
    return Expanded(
      child: DragTarget<String>(
        onAccept: (task) {
          setState(() {
            if (!tasks.contains(task)) {
              tasks.add(task);
            }
            otherTasks1.remove(task);
            otherTasks2.remove(task);
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Draggable<String>(
                        data: tasks[index],
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Expanded(
                            child: Row(
                              
                              children: [
                                Text(tasks[index]),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _removeTask(tasks[index], tasks); // حذف تسک از لیست جاری
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        feedback: Material(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 177, 194, 208),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(tasks[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // اضافه کردن تسک جدید
                if (title == "انجام نشده")
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _taskController,
                            decoration: InputDecoration(
                              labelText: 'تسک جدید',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addTask, // وقتی روی دکمه کلیک می‌شود تسک جدید اضافه می‌شود
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مدیریت تسک‌ها")),
      body: Row(
        children: [
          _buildTaskColumn("انجام نشده", notStartedTasks, inProgressTasks, doneTasks, Colors.red[100]!),
          _buildTaskColumn("در حال انجام", inProgressTasks, notStartedTasks, doneTasks, const Color.fromARGB(255, 186, 123, 15)!),
          _buildTaskColumn("انجام شده", doneTasks, notStartedTasks, inProgressTasks, Colors.green[100]!),
        ],
      ),
    );
  }
}
