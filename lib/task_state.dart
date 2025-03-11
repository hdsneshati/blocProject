// task_state.dart
abstract class TaskState {}

class TaskInitialState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<String> tasks;
  TaskLoadedState(this.tasks);
}

class TaskErrorState extends TaskState {}
