import 'package:intl/intl.dart';
import 'package:todo_app/database/task_helper.dart';

class Task {
  final int? id;
  final String name;
  final int priority;
  final DateTime deadline;
  final String memo;
  int completed;

  Task({
    this.id,
    required this.name,
    required this.priority,
    required this.deadline,
    required this.memo,
    required this.completed,
  });

  Task copy({
    int? id,
    String? name,
    int? priority,
    DateTime? deadline,
    String? memo,
    int? completed,
  }) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        deadline: deadline ?? this.deadline,
        memo: memo ?? this.memo,
        completed: completed ?? this.completed,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[columnId] as int,
        name: json[columnName] as String,
        priority: json[columnPriority] as int,
        deadline: DateTime.parse(json[columnDeadline] as String),
        memo: json[columnMemo] as String,
        completed: json[columnCompleted] as int,
      );

  Map<String, Object?> toJson() => {
        columnName: name,
        columnPriority: priority,
        columnDeadline: DateFormat('yyyy-MM-dd HH:mm:ss').format(deadline),
        columnMemo: memo,
        columnCompleted: completed,
      };
}
