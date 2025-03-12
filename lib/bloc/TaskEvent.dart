import 'package:equatable/equatable.dart';
import './TaskModel.dart';
abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);  // ایجاد رویداد اضافه کردن وظیفه
}

class RemoveTask extends TaskEvent {
  final Task task;
  RemoveTask(this.task);  // ایجاد رویداد حذف وظیفه
}

class EditTask extends TaskEvent {
  final Task oldTask;
  final Task newTask;
  EditTask({required this.oldTask, required this.newTask});  // ایجاد رویداد ویرایش وظیفه

  @override
  List<Object?> get props => [oldTask, newTask];
}