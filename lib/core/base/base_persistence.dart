import 'package:hive_flutter/hive_flutter.dart';
import 'base_item.dart';

abstract class BasePersistence<T extends BaseItem> {
  final String boxName;
  final String deletedBoxName;

  BasePersistence({
    required this.boxName,
    required this.deletedBoxName,
  });

  // Box getters
  Future<Box<T>> get box async => await Hive.openBox<T>(boxName);
  Future<Box<T>> get deletedBox async => await Hive.openBox<T>(deletedBoxName);

  // Core persistence methods
  Future<void> saveItem(T item) async {
    final itemBox = await box;
    await itemBox.put(item.id, item);
  }

  Future<void> deleteItem(String id) async {
    final itemBox = await box;
    await itemBox.delete(id);
  }

  Future<T?> getItem(String id) async {
    final itemBox = await box;
    return itemBox.get(id);
  }

  Future<List<T>> getAllItems() async {
    final itemBox = await box;
    return itemBox.values.toList();
  }

  // Pin state handling
  Future<void> updatePinState(String id, bool isPinned) async {
    final itemBox = await box;
    final item = await getItem(id);
    if (item != null) {
      final updatedItem = item.copyWith(isPinned: isPinned) as T;
      await itemBox.put(id, updatedItem);
    }
  }

  // Cleanup methods
  Future<void> cleanupOldItems(int days) async {
    final itemBox = await deletedBox;
    final now = DateTime.now();
    final items = itemBox.values.toList();

    for (final item in items) {
      if (item.deletedAt != null) {
        final difference = now.difference(item.deletedAt!);
        if (difference.inDays >= days) {
          await itemBox.delete(item.id);
        }
      }
    }
  }
}
