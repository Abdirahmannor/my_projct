import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Deleted'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Complete All Projects',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Complete All Projects'),
                    content: const Text(
                        'Are you sure you want to complete all projects?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          projectProvider.completeAllProjects();
                          Navigator.pop(context);
                        },
                        child: const Text('Complete All'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildProjectList(projectProvider.projects, 'active'),
            _buildProjectList(projectProvider.completedProjects, 'completed'),
            _buildProjectList(projectProvider.deletedProjects, 'deleted'),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(List<Map<String, dynamic>> projects, String type) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        return projects.isEmpty
            ? Center(
                child: Text('No $type projects'),
              )
            : ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ListTile(
                    title: Text(project['title']),
                    subtitle: Text(project['status']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (type == 'active')
                          IconButton(
                            icon: const Icon(Icons.check),
                            tooltip: 'Complete Project',
                            onPressed: () =>
                                projectProvider.completeProject(index),
                          ),
                        if (type == 'completed' || type == 'deleted')
                          IconButton(
                            icon: const Icon(Icons.restore),
                            tooltip: 'Restore Project',
                            onPressed: () =>
                                projectProvider.restoreProject(index),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: type == 'deleted'
                              ? 'Delete Permanently'
                              : 'Delete',
                          onPressed: () {
                            if (type == 'deleted') {
                              projectProvider.permanentlyDeleteProject(index);
                            } else if (type == 'completed') {
                              projectProvider.deleteCompletedProject(index);
                            } else {
                              projectProvider.deleteProject(index);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}
