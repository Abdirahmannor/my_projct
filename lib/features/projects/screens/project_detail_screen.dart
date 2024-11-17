import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:hive/hive.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('=== ProjectDetailScreen Debug ===');
    print('Building ProjectDetailScreen');

    try {
      print('Project ID: ${project.id}');
      print('Project Name: ${project.name}');
      print('Project data: ${project.toMap()}');

      if (!Hive.isBoxOpen('projects')) {
        print('Error: Projects box is not open');
        return _buildErrorScreen(context, 'Database error: Box is not open');
      }

      final projectsBox = Hive.box<Project>('projects');
      final deletedBox = Hive.box<Project>('deleted_projects');

      print('Projects in main box: ${projectsBox.length}');
      print('Projects in deleted box: ${deletedBox.length}');

      // Validate project data
      if (project.name.isEmpty) {
        return _buildErrorScreen(context, 'Invalid project: Name is empty');
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(project.description ?? 'No description'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          'Start Date',
                          _formatDate(project.startDate),
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Due Date',
                          _formatDate(project.dueDate),
                        ),
                        const Divider(),
                        _buildInfoRow(context, 'Status', project.status),
                        const Divider(),
                        _buildInfoRow(context, 'Priority', project.priority),
                        const Divider(),
                        _buildInfoRow(context, 'Category', project.category),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in ProjectDetailScreen: $e');
      print('Stack trace: $stackTrace');
      return _buildErrorScreen(context, 'Error: $e');
    }
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildErrorScreen(BuildContext context, String error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error loading project details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
