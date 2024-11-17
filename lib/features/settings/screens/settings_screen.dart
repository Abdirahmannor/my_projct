import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: true, // Connect to your theme provider
              onChanged: (value) {
                // Implement theme switching
              },
            ),
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}
