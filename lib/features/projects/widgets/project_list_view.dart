import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/project.dart';
import 'project_list_item.dart';
import 'project_grid_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProjectListView extends StatefulWidget {
  final List<Project> projects;
  final List<bool> checkedProjects;
  final bool showArchived;
  final bool showRecycleBin;
  final bool isListView;
  final Function(int, bool?) onCheckboxChange;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final Function(int) onRestore;
  final Function(bool?) onToggleAll;
  final Function() onRestoreAll;
  final bool Function(int) filterProject;

  const ProjectListView({
    super.key,
    required this.projects,
    required this.checkedProjects,
    required this.showArchived,
    required this.showRecycleBin,
    required this.isListView,
    required this.onCheckboxChange,
    required this.onEdit,
    required this.onDelete,
    required this.onRestore,
    required this.onToggleAll,
    required this.onRestoreAll,
    required this.filterProject,
  });

  @override
  State<ProjectListView> createState() => _ProjectListViewState();
}

class _ProjectListViewState extends State<ProjectListView> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Expanded(
            child: widget.isListView ? _buildListView() : _buildGridView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: widget.showArchived || widget.showRecycleBin
                ? Tooltip(
                    message: 'Restore all projects',
                    child: IconButton(
                      icon: Icon(
                        PhosphorIcons.arrowCounterClockwise(
                            PhosphorIconsStyle.bold),
                        size: 18,
                        color: AppColors.accent,
                      ),
                      onPressed: widget.onRestoreAll,
                      padding: EdgeInsets.zero,
                    ),
                  )
                : Tooltip(
                    message: 'Select all projects',
                    child: Checkbox(
                      value: widget.checkedProjects.every((checked) => checked),
                      onChanged: widget.onToggleAll,
                      tristate: true,
                    ),
                  ),
          ),
          // Add your other header items here
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.projects.length,
      itemBuilder: (context, index) {
        if (!widget.filterProject(index)) {
          return const SizedBox.shrink();
        }

        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndex = index),
          onExit: (_) => setState(() => hoveredIndex = null),
          child: ProjectListItem(
            project: widget.projects[index],
            isChecked: widget.showArchived || widget.showRecycleBin
                ? true
                : widget.checkedProjects[index],
            onCheckChanged: (value) => widget.onCheckboxChange(index, value),
            onEdit: widget.showArchived || widget.showRecycleBin
                ? () {}
                : () => widget.onEdit(index),
            onDelete: widget.showArchived || widget.showRecycleBin
                ? () {}
                : () => widget.onDelete(index),
            onRestore: widget.showArchived || widget.showRecycleBin
                ? () => widget.onRestore(index)
                : null,
            isHovered: hoveredIndex == index,
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.projects.length,
      itemBuilder: (context, index) {
        if (!widget.filterProject(index)) {
          return const SizedBox.shrink();
        }

        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndex = index),
          onExit: (_) => setState(() => hoveredIndex = null),
          child: ProjectGridItem(
            project: widget.projects[index],
            isChecked: widget.showArchived || widget.showRecycleBin
                ? true
                : widget.checkedProjects[index],
            onCheckChanged: (value) => widget.onCheckboxChange(index, value),
            onEdit: widget.showArchived || widget.showRecycleBin
                ? () {}
                : () => widget.onEdit(index),
            onDelete: widget.showArchived || widget.showRecycleBin
                ? () {}
                : () => widget.onDelete(index),
            onRestore: widget.showArchived || widget.showRecycleBin
                ? () => widget.onRestore(index)
                : null,
            isHovered: hoveredIndex == index,
          ),
        );
      },
    );
  }
}
