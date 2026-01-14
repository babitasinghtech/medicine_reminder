import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Medicine extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String dose;

  @HiveField(2)
  final int hour;

  @HiveField(3)
  final int minute;
  @HiveField(4)
  final int alarmId;

  Medicine({
    required this.name,
    required this.dose,
    required this.hour,
    required this.minute,
    required this.alarmId,
  });
}
