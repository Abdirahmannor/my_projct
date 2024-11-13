import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/add_project_dialog.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String? selectedPriority;
  String? selectedStatus;
  List<bool> checkedProjects = List.generate(5, (_) => false);
  bool showArchived = false;
  bool showAllProjects = true;
  bool isListView = true;
  int? hoveredIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  String getPriorityText(String? priority) {
    if (priority == null) return 'All Priority';
    return priority[0].toUpperCase() + priority.substring(1);
  }

  String getStatusText(String? status) {
    if (status == null) return 'All Status';
    return status[0].toUpperCase() + status.substring(1);
  }

  bool _filterProject(int index) {
    if (searchQuery.isNotEmpty) {
      String projectName = 'Project ${index + 1}'.toLowerCase();
      if (!projectName.contains(searchQuery.toLowerCase())) return false;
    }

    if (showAllProjects) {
      if (selectedStatus != null) {
        String projectStatus = checkedProjects[index]
            ? 'completed'
            : index % 3 == 1
                ? 'in progress'
                : 'delayed';
        if (projectStatus != selectedStatus) return false;
      }
      if (selectedPriority == null) return true;

      String priority = index % 3 == 0
          ? 'high'
          : index % 3 == 1
              ? 'medium'
              : 'low';

      return priority == selectedPriority;
    }

    if (showArchived && !checkedProjects[index]) return false;
    return true;
  }

  void _toggleAllProjects(bool? value) {
    setState(() {
      checkedProjects = List.generate(5, (_) => value ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with different background
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddProjectDialog(),
                          );
                        },
                        icon: Icon(PhosphorIcons.plus(), size: 18),
                        label: const Text('Add Project'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5722),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Filter bar row
                  Row(
                    children: [
                      // All project button (separate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: showAllProjects
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showAllProjects = true;
                              showArchived = false;
                            });
                          },
                          icon: Icon(
                            PhosphorIcons.folder(),
                            size: 18,
                            color: showAllProjects ? Colors.white : null,
                          ),
                          label: Text(
                            'All Projects',
                            style: TextStyle(
                              color: showAllProjects ? Colors.white : null,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Archived button (separate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: showArchived
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showArchived = true;
                              showAllProjects = false;
                            });
                          },
                          icon: Icon(
                            PhosphorIcons.archive(),
                            size: 18,
                            color: showArchived ? Colors.white : null,
                          ),
                          label: Text(
                            'Archived',
                            style: TextStyle(
                              color: showArchived ? Colors.white : null,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Sort dropdown
                      PopupMenuButton<String>(
                        offset: const Offset(0, 40),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(PhosphorIcons.funnel(), size: 18),
                              const SizedBox(width: 8),
                              Text(getPriorityText(selectedPriority)),
                              const SizedBox(width: 12),
                              Icon(PhosphorIcons.caretDown(), size: 18),
                            ],
                          ),
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'all',
                            child: Text('All Priority'),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'high',
                            child: Text(
                              'High',
                              style: TextStyle(color: Colors.red[400]),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'medium',
                            child: Text(
                              'Medium',
                              style: TextStyle(color: Colors.orange[400]),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'low',
                            child: Text(
                              'Low',
                              style: TextStyle(color: Colors.green[400]),
                            ),
                          ),
                        ],
                        onSelected: (String value) {
                          setState(() {
                            selectedPriority = value == 'all' ? null : value;
                          });
                        },
                      ),

                      const SizedBox(width: 16),

                      // Search bar
                      Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search projects...',
                            prefixIcon:
                                Icon(PhosphorIcons.magnifyingGlass(), size: 18),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(PhosphorIcons.x(), size: 16),
                                    onPressed: () {
                                      setState(() {
                                        searchQuery = '';
                                        searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // List view icon
                      Tooltip(
                        message: 'List View',
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => hoveredIndex = -1),
                          onExit: (_) => setState(() => hoveredIndex = null),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isListView
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isListView
                                    ? Theme.of(context).primaryColor
                                    : hoveredIndex == -1
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isListView = true;
                                });
                              },
                              icon: Icon(
                                PhosphorIcons.list(),
                                size: 18,
                                color: isListView
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Grid view icon
                      Tooltip(
                        message: 'Grid View',
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => hoveredIndex = -2),
                          onExit: (_) => setState(() => hoveredIndex = null),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: !isListView
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: !isListView
                                    ? Theme.of(context).primaryColor
                                    : hoveredIndex == -2
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isListView = false;
                                });
                              },
                              icon: Icon(
                                PhosphorIcons.squaresFour(),
                                size: 18,
                                color: !isListView
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Checkbox(
                            value: checkedProjects.every((checked) => checked),
                            onChanged: _toggleAllProjects,
                            tristate: true,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Project Name',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Start Date',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Due Date',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Tasks',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Priority',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: PopupMenuButton<String>(
                            offset: const Offset(0, 40),
                            child: Row(
                              children: [
                                Text(
                                  'Status',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(width: 4),
                                Icon(PhosphorIcons.caretDown(), size: 14),
                              ],
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'all',
                                child: Text('All Status'),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'completed',
                                child: Text(
                                  'Completed',
                                  style: TextStyle(color: Colors.green[400]),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'in progress',
                                child: Text(
                                  'In Progress',
                                  style: TextStyle(color: Colors.blue[400]),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delayed',
                                child: Text(
                                  'Delayed',
                                  style: TextStyle(color: Colors.red[400]),
                                ),
                              ),
                            ],
                            onSelected: (String value) {
                              setState(() {
                                selectedStatus = value == 'all' ? null : value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Actions',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Project List Items
                  Expanded(
                    child: isListView
                        ? ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              if (!_filterProject(index))
                                return const SizedBox.shrink();
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => hoveredIndex = index),
                                onExit: (_) =>
                                    setState(() => hoveredIndex = null),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hoveredIndex == index
                                        ? Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.8)
                                        : Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: index % 3 == 0
                                          ? Colors.red[400]!.withOpacity(0.3)
                                          : index % 3 == 1
                                              ? Colors.orange[400]!
                                                  .withOpacity(0.3)
                                              : Colors.green[400]!
                                                  .withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: hoveredIndex == index
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        child: Checkbox(
                                          value: checkedProjects[index],
                                          onChanged: (value) {
                                            setState(() {
                                              checkedProjects[index] =
                                                  value ?? false;
                                            });
                                          },
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Project ${index + 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            decoration: checkedProjects[index]
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            decorationColor:
                                                Colors.white54, // Line color
                                            decorationThickness:
                                                2, // Line thickness
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '15 Sep, 2024',
                                          style: TextStyle(
                                            fontSize: 14,
                                            decoration: checkedProjects[index]
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            decorationColor: Colors.white54,
                                            decorationThickness: 2,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '15 Oct, 2024',
                                          style: TextStyle(
                                            fontSize: 14,
                                            decoration: checkedProjects[index]
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            decorationColor: Colors.white54,
                                            decorationThickness: 2,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '5',
                                          style: TextStyle(
                                            fontSize: 14,
                                            decoration: checkedProjects[index]
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            decorationColor: Colors.white54,
                                            decorationThickness: 2,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: index % 3 == 0
                                                ? const Color(0xFF442926)
                                                : index % 3 == 1
                                                    ? const Color(0xFF3D3425)
                                                    : const Color(0xFF2A3524),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            index % 3 == 0
                                                ? 'High'
                                                : index % 3 == 1
                                                    ? 'Medium'
                                                    : 'Low',
                                            style: TextStyle(
                                              color: index % 3 == 0
                                                  ? Colors.red[400]
                                                  : index % 3 == 1
                                                      ? Colors.orange[400]
                                                      : Colors.green[400],
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: checkedProjects[index]
                                                ? const Color(0xFF243524)
                                                : index % 3 == 1
                                                    ? const Color(0xFF252D3D)
                                                    : const Color(0xFF442926),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            checkedProjects[index]
                                                ? 'Completed'
                                                : index % 3 == 1
                                                    ? 'In Progress'
                                                    : 'Delayed',
                                            style: TextStyle(
                                              color: checkedProjects[index]
                                                  ? Colors.green[400]
                                                  : index % 3 == 1
                                                      ? Colors.blue[400]
                                                      : Colors.red[400],
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(PhosphorIcons.eye(),
                                                  size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  PhosphorIcons.pencilSimple(),
                                                  size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(PhosphorIcons.trash(),
                                                  size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Show 3 items per row
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio:
                                  1.5, // Width:Height ratio of each grid item
                            ),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              if (!_filterProject(index))
                                return const SizedBox.shrink();
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => hoveredIndex = index),
                                onExit: (_) =>
                                    setState(() => hoveredIndex = null),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: hoveredIndex == index
                                        ? Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.8)
                                        : Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: index % 3 == 0
                                          ? Colors.red[400]!.withOpacity(0.3)
                                          : index % 3 == 1
                                              ? Colors.orange[400]!
                                                  .withOpacity(0.3)
                                              : Colors.green[400]!
                                                  .withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: hoveredIndex == index
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: checkedProjects[index],
                                            onChanged: (value) {
                                              setState(() {
                                                checkedProjects[index] =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Project ${index + 1}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    checkedProjects[index]
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Add dates and tasks info
                                      Row(
                                        children: [
                                          Icon(PhosphorIcons.calendar(),
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '15 Oct, 2024',
                                            style: TextStyle(
                                              fontSize: 12,
                                              decoration: checkedProjects[index]
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(PhosphorIcons.listChecks(),
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '5 Tasks',
                                            style: TextStyle(
                                              fontSize: 12,
                                              decoration: checkedProjects[index]
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: checkedProjects[index]
                                              ? const Color(0xFF243524)
                                              : const Color(0xFF252D3D),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          checkedProjects[index]
                                              ? 'Completed'
                                              : 'In Progress',
                                          style: TextStyle(
                                            color: checkedProjects[index]
                                                ? Colors.green[400]
                                                : Colors.blue[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Existing bottom row with priority and actions
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: index % 3 == 0
                                                  ? const Color(0xFF442926)
                                                  : index % 3 == 1
                                                      ? const Color(0xFF3D3425)
                                                      : const Color(0xFF2A3524),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              index % 3 == 0
                                                  ? 'High'
                                                  : index % 3 == 1
                                                      ? 'Medium'
                                                      : 'Low',
                                              style: TextStyle(
                                                color: index % 3 == 0
                                                    ? Colors.red[400]
                                                    : index % 3 == 1
                                                        ? Colors.orange[400]
                                                        : Colors.green[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(PhosphorIcons.eye(),
                                                    size: 16),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    PhosphorIcons
                                                        .pencilSimple(),
                                                    size: 16),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    PhosphorIcons.trash(),
                                                    size: 16),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
