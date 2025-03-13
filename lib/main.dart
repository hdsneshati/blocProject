import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/TaskBloc.dart';
import 'bloc/TaskModel.dart';
import 'bloc/TaskEvent.dart';
import 'bloc/TaskState.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => TaskBloc(),
      child: const MyApp(),
    ),
  );
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

class TodoScreen extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مدیریت تسک‌ها")),
      body: BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoaded) {
      return Row(
        children: [
          _buildTaskColumn(context, "انجام نشده", "notStarted", state.tasks.where((t) => t.status == 'notStarted').toList(), Colors.red[100]!),
          _buildTaskColumn(context, "در حال انجام", "inProgress", state.tasks.where((t) => t.status == 'inProgress').toList(), Colors.orange[100]!),
          _buildTaskColumn(context, "انجام شده", "done", state.tasks.where((t) => t.status == 'done').toList(), Colors.green[100]!),
        ],
      );
    }
    return Center(child: CircularProgressIndicator());
  },
),

    );
  }

  Widget _buildTaskColumn(BuildContext context, String title, String status, List<Task> tasks, Color color) {
  return Expanded(
    child: DragTarget<Task>(
      onAccept: (task) {
        BlocProvider.of<TaskBloc>(context).add(UpdateTaskStatus(task: task, newStatus: status));
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskItem(context, tasks[index]);
                  },
                ),
              ),
              if (status == "notStarted") _buildAddTaskField(context), // اضافه کردن فیلد فقط در ستون "انجام نشده"
            ],
          ),
        );
      },
    ),
  );
}


  Widget _buildTaskItem(BuildContext context, Task task) {
  return Draggable<Task>(
    data: task,
    feedback: Material(
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey[300],
        child: Text(task.title, style: TextStyle(fontSize: 16)),
      ),
    ),
    childWhenDragging: Opacity(opacity: 0.5, child: ListTile(title: Text(task.title))),
    child: ListTile(
      title: Text(task.title),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          BlocProvider.of<TaskBloc>(context).add(RemoveTask(task));
        },
      ),
    ),
  );
}


  Widget _buildAddTaskField(BuildContext context) {
    return Padding(
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
            onPressed: () {
              final taskTitle = _taskController.text.trim();
              if (taskTitle.isNotEmpty) {
                BlocProvider.of<TaskBloc>(context).add(
                  AddTask(Task(title: taskTitle, status: 'notStarted')),
                );
                _taskController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
