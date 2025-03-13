

import 'package:flutter_bloc/flutter_bloc.dart';
import 'TaskEvent.dart';
import 'TaskState.dart';
import 'TaskModel.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskLoaded([])) {
    on<AddTask>((event, emit) {
      final currentState = state as TaskLoaded;
      final updatedTasks = List<Task>.from(currentState.tasks)..add(event.task);
      emit(TaskLoaded(updatedTasks));
    });

    on<RemoveTask>((event, emit) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.tasks.where((task) => task != event.task).toList();
      emit(TaskLoaded(updatedTasks));
    });

    on<EditTask>((event, emit) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        return task == event.oldTask ? event.newTask : task;
      }).toList();
      emit(TaskLoaded(updatedTasks));
    });

    on<UpdateTaskStatus>((event, emit) {
  final currentState = state as TaskLoaded;
  final updatedTasks = currentState.tasks.map((task) {
    return task == event.task ? task.copyWith(status: event.newStatus) : task;
      }).toList();

    emit(TaskLoaded(updatedTasks));
    });

  }
}
