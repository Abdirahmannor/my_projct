import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF272935),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _buildEventItem(
            color: Colors.red,
            title: 'Math Exam',
            time: 'Tomorrow, 9:00 AM',
            icon: PhosphorIcons.exam(PhosphorIconsStyle.bold),
          ),
          const SizedBox(height: 16),
          _buildEventItem(
            color: Colors.blue,
            title: 'Project Meeting',
            time: 'Thursday, 2:30 PM',
            icon: PhosphorIcons.users(PhosphorIconsStyle.bold),
          ),
          const SizedBox(height: 16),
          _buildEventItem(
            color: Colors.purple,
            title: 'Physics Lab',
            time: 'Friday, 11:00 AM',
            icon: PhosphorIcons.atom(PhosphorIconsStyle.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required Color color,
    required String title,
    required String time,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Icon(
          icon,
          color: color,
          size: 24,
        ),
      ],
    );
  }
}
