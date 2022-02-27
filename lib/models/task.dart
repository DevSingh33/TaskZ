import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(1)
  final String taskName;

  @HiveField(2)
  final DateTime taskId;

  @HiveField(10)
  final DateTime createdDate;

  @HiveField(4)
  final String deadLineDate;

  @HiveField(5)
  final String createdTime;

  @HiveField(6)
  final String deadLineTime;

  @HiveField(7)
  DateTime completedOn;

  @HiveField(8)
  final bool isImportant;

  @HiveField(9)
  bool isFinished;

  Task({
    required this.createdTime,
    required this.deadLineDate,
    required this.deadLineTime,
    required this.taskName,
    required this.createdDate,
    required this.taskId,
    required this.completedOn,
    this.isFinished = false,
    this.isImportant = false,
  });
}
