
abstract class TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String task;
  AddTaskEvent(this.task);
}

class RemoveTaskEvent extends TaskEvent {
  final String task;
  RemoveTaskEvent(this.task);
}
