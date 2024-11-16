import 'package:hive_flutter/hive_flutter.dart';
import 'base_item.dart';

abstract class BaseDatabase<T extends BaseItem> {
  final String boxName;
  final String deletedBoxName;

  BaseDatabase({
    required this.boxName,
    required this.deletedBoxName,
  });

  // Get box instances
  Future<Box<T>> get box async => await Hive.openBox<T>(boxName);
  Future<Box<T>> get deletedBox async => await Hive.openBox<T>(deletedBoxName);

  // CRUD Operations
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Future<T?> get(String id);
  Future<List<T>> getAll();

  // Common Operations
  Future<void> moveToRecycleBin(T item);
  Future<void> restoreFromRecycleBin(String id);
  Future<void> permanentlyDelete(String id);
  Future<List<T>> getDeletedItems();

  // Cleanup
  Future<void> cleanupOldItems();
}
