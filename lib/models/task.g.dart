// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      createdTime: fields[5] as String,
      deadLineDate: fields[4] as String,
      deadLineTime: fields[6] as String,
      taskName: fields[1] as String,
      createdDate: fields[10] as DateTime,
      taskId: fields[2] as DateTime,
      completedOn: fields[7] as DateTime,
      isFinished: fields[9] as bool,
      isImportant: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj.taskId)
      ..writeByte(10)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.deadLineDate)
      ..writeByte(5)
      ..write(obj.createdTime)
      ..writeByte(6)
      ..write(obj.deadLineTime)
      ..writeByte(7)
      ..write(obj.completedOn)
      ..writeByte(8)
      ..write(obj.isImportant)
      ..writeByte(9)
      ..write(obj.isFinished);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
