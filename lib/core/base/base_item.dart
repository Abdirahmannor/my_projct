import 'package:hive/hive.dart';

part 'base_item.g.dart';

@HiveType(typeId: 0)
class BaseItem extends HiveObject {
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
  }) {
    return BaseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      deletedAt: deletedAt ?? this.deletedAt,
      lastRestoredDate: lastRestoredDate ?? this.lastRestoredDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'isPinned': isPinned,
      'deletedAt': deletedAt?.toIso8601String(),
      'lastRestoredDate': lastRestoredDate?.toIso8601String(),
    };
  }

  factory BaseItem.fromMap(Map<String, dynamic> map) {
    return BaseItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      status: map['status'],
      isPinned: map['isPinned'],
      deletedAt:
          map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      lastRestoredDate: map['lastRestoredDate'] != null
          ? DateTime.parse(map['lastRestoredDate'])
          : null,
    );
  }
}
