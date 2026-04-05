import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AnalogClock extends StatelessWidget {
  const AnalogClock({super.key, required this.time, this.size = 120});

  final DateTime time;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _AnalogClockPainter(time: time)),
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  _AnalogClockPainter({required this.time});

  final DateTime time;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw circle outline
    final circlePaint = Paint()
      ..color = AppColors.onSurface.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, circlePaint);

    // Draw tick marks
    final tickPaint = Paint()
      ..color = AppColors.onSurface.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final startX = center.dx + (radius - 8) * math.cos(angle - math.pi / 2);
      final startY = center.dy + (radius - 8) * math.sin(angle - math.pi / 2);
      final endX = center.dx + (radius - 12) * math.cos(angle - math.pi / 2);
      final endY = center.dy + (radius - 12) * math.sin(angle - math.pi / 2);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
    }

    // Calculate angles
    final hourAngle =
        ((time.hour % 12) + time.minute / 60) * 30 * math.pi / 180;
    final minuteAngle = time.minute * 6 * math.pi / 180;

    // Draw hour hand
    final hourPaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final hourLength = radius * 0.5;
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourLength * math.cos(hourAngle - math.pi / 2),
        center.dy + hourLength * math.sin(hourAngle - math.pi / 2),
      ),
      hourPaint,
    );

    // Draw minute hand
    final minutePaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final minuteLength = radius * 0.75;
    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteLength * math.cos(minuteAngle - math.pi / 2),
        center.dy + minuteLength * math.sin(minuteAngle - math.pi / 2),
      ),
      minutePaint,
    );

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
