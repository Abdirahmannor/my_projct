import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WeeklyActivityChart extends StatelessWidget {
  const WeeklyActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: ChartPainter(
              lineColor: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) => Text(
              _getDayLabel(index),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  String _getDayLabel(int index) {
    switch (index) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }
}

class ChartPainter extends CustomPainter {
  final Color lineColor;

  ChartPainter({
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.4,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width * 0.9,
      size.height * 0.9,
      size.width,
      size.height * 0.7,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
