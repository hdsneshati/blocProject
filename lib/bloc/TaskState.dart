import 'package:equatable/equatable.dart';
import './TaskModel.dart';
abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}


class TaskLoaded extends TaskState {
  final List<Task> tasks;  // لیست وظایف موجود
  TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}