import 'package:hive/hive.dart';

@HiveType(typeId: 0)
abstract class BaseItem {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String priority;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final bool? isPinned;

  @HiveField(7)
  final DateTime? deletedAt;

  @HiveField(8)
  final DateTime? lastRestoredDate;

  BaseItem({
    this.id,
    required this.name,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.isPinned,
    this.deletedAt,
    this.lastRestoredDate,
  });

  BaseItem copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
  });

  Map<String, dynamic> toMap();
}
