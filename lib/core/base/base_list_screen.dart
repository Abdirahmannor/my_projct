import 'package:flutter/material.dart';
import 'base_view_manager.dart';
import 'base_item.dart';
import 'base_state.dart';
import 'base_filter_methods.dart';
import 'base_state_methods.dart';

abstract class BaseListScreen<T extends BaseItem> extends StatefulWidget {
  const BaseListScreen({super.key});

  @override
  BaseListScreenState<T> createState();
}

abstract class BaseListScreenState<T extends BaseItem>
    extends State<BaseListScreen<T>>
    with BaseFilterMethods<T>, BaseStateMethods<T> {
  // Core managers
  final viewManager = BaseViewManager();
  late final BaseState<T> state;

  // Abstract methods to be implemented by subclasses
  Widget buildListView(List<T> items);
  Widget buildGridView(List<T> items);
  Widget buildHeader();
  Widget buildFilterBar();

  // Lifecycle methods
  @override
  void initState() {
    super.initState();
    initializeState();
    loadItems();
  }

  // Initialize state
  void initializeState() {
    state = createState();
  }

  // Abstract method to create state
  BaseState<T> createState();

  // Load items
  Future<void> loadItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            buildHeader(),
            buildFilterBar(),
            Expanded(
              child: viewManager.buildView(
                listView: buildListView(getFilteredItems()),
                gridView: buildGridView(getFilteredItems()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get filtered items based on current state
  List<T> getFilteredItems() {
    return filterItems(
      items: state.showArchived
          ? state.archivedItems
          : state.showRecycleBin
              ? state.deletedItems
              : state.items,
      searchQuery: state.searchQuery,
      priority: state.selectedPriority,
      status: state.selectedStatus,
      dateRange: state.selectedDateRange,
      nameSort: state.selectedNameSort,
      dateSort: state.selectedStartDateSort,
    );
  }
}
