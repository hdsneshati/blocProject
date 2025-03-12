import 'dart:convert';  // برای استفاده از jsonEncode و jsonDecode
import 'package:equatable/equatable.dart';
class Task extends Equatable {
  final String title;
  final String status;  // اضافه کردن فیلد وضعیت

  Task({required this.title, this.status = 'notStarted'});

  Task copyWith({String? title, String? status}) {
    return Task(
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      status: json['status'] ?? 'notStarted',
    );
  }

  @override
  List<Object?> get props => [title, status];
}
