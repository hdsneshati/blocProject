import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'TaskModel.dart';
import 'TaskEvent.dart';
import 'TaskState.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskLoaded([])) {
    _loadTasks();  // هنگام ایجاد BLoC، داده‌های ذخیره‌شده بارگذاری می‌شوند

    on<AddTask>((event, emit) {
      final currentState = state as TaskLoaded;
      final updatedTasks = List<Task>.from(currentState.tasks)..add(event.task);
      _saveTasks(updatedTasks);  // ذخیره داده‌های جدید
      emit(TaskLoaded(updatedTasks));  // انتشار وضعیت جدید
    });

    on<RemoveTask>((event, emit) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.tasks.where((task) => task != event.task).toList();
      _saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    });

    on<EditTask>((event, emit) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        return task == event.oldTask ? event.newTask : task;
      }).toList();
      _saveTasks(updatedTasks);
      emit(TaskLoaded(updatedTasks));
    });
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', taskListJson);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = prefs.getString('tasks');
    if (taskListJson != null) {
      final taskList = (jsonDecode(taskListJson) as List)
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(TaskLoaded(taskList));
    } else {
      emit(TaskLoaded([]));
    }
  }
}
