// task_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';

import './task_event.dart';
import './task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  List<String> tasks = [];

  TaskBloc() : super(TaskInitialState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is AddTaskEvent) {
      tasks.add(event.task);
      yield TaskLoadedState(tasks);
    } else if (event is RemoveTaskEvent) {
      tasks.remove(event.task);
      yield TaskLoadedState(tasks);
    }
  }
}
