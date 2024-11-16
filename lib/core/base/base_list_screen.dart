import 'package:flutter/material.dart';
import 'base_item.dart';
import 'base_database.dart';

abstract class BaseListScreen<T extends BaseItem> extends StatefulWidget {
  const BaseListScreen({super.key});

  @override
  State<BaseListScreen<T>> createState();
}

abstract class BaseListScreenState<T extends BaseItem,
    S extends BaseListScreen<T>> extends State<S> {
  // Common state variables
  String? selectedPriority;
  String? selectedStatus;
  List<bool> checkedItems = [];
  bool showArchived = false;
  bool showAllItems = true;
  bool isListView = true;
  int? hoveredIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool _isLoading = false;
  List<T> archivedItems = [];
  List<bool> archivedCheckedItems = [];
  bool archivedSelectAll = false;
  List<T> items = [];
  final Map<int, String> originalStatuses = {};
  bool showRecycleBin = false;
  List<T> deletedItems = [];
  List<bool> recycleBinCheckedItems = [];
  bool recycleBinSelectAll = false;

  // Abstract methods that subclasses must implement
  BaseDatabase<T> get database;
  String get screenTitle;
  Widget buildListItem(T item, int index);
  Widget buildGridItem(T item, int index);

  @override
  Widget build(BuildContext context) {
    // Will implement shared UI structure
    return Container();
  }

  // Common functionality methods will go here
}
