import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../perceptron/data/models/training_point.dart';

class DecisionBoundaryPainter extends CustomPainter {
  final double w1, w2, w0;
  final List<TrainingPoint> points;
  final bool isXor;
  final Map<String, double>? extraWeights;

  DecisionBoundaryPainter({
    required this.w1,
    required this.w2,
    required this.w0,
    required this.points,
    this.isXor = false,
    this.extraWeights,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double min = AppConstants.gridMin;
    final double max = AppConstants.gridMax;

    final double scaleX = size.width / (max - min);
    final double scaleY = size.height / (max - min);

    Offset toOffset(double x, double y) {
      return Offset((x - min) * scaleX, size.height - (y - min) * scaleY);
    }

    const double step = 0.08;

    for (double x = min; x <= max; x += step) {
      for (double y = min; y <= max; y += step) {
        double prediction;

        if (isXor && extraWeights != null) {
          final h1 = 1 / (1 + math.exp(-(w1 * x + w2 * y + w0)));
          final h2 = 1 / (1 + math.exp(-(extraWeights!['w21']! * x +
              extraWeights!['w22']! * y +
              extraWeights!['b2']!)));
          prediction = 1 / (1 + math.exp(-(extraWeights!['wo1']! * h1 +
              extraWeights!['wo2']! * h2 +
              extraWeights!['bo']!)));
        } else {
          prediction = w1 * x + w2 * y - w0;
          prediction = prediction > 0 ? 1 : 0;
        }

        final Color color = Color.lerp(Colors.redAccent, Colors.cyanAccent, prediction.clamp(0, 1))!;
        canvas.drawCircle(toOffset(x, y), 4.5, Paint()..color = color.withOpacity(0.5));
      }
    }

    if (!isXor && w2.abs() > 0.001) {
      final Paint linePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final double y1 = (w0 - w1 * min) / w2;
      final double y2 = (w0 - w1 * max) / w2;
      canvas.drawLine(toOffset(min, y1), toOffset(max, y2), linePaint);
    }

    if (isXor && extraWeights != null) {
      final Paint contourPaint = Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      const int n = 100;
      for (int i = 0; i < n; i++) {
        double x = min + (i / n) * (max - min);
        double y = min + (i / n) * (max - min);

        final h1 = 1 / (1 + math.exp(-(w1 * x + w2 * y + w0)));
        final h2 = 1 / (1 + math.exp(-(extraWeights!['w21']! * x +
            extraWeights!['w22']! * y +
            extraWeights!['b2']!)));
        final pred = 1 / (1 + math.exp(-(extraWeights!['wo1']! * h1 +
            extraWeights!['wo2']! * h2 +
            extraWeights!['bo']!)));

        if ((pred - 0.5).abs() < 0.05) {
          canvas.drawCircle(toOffset(x, y), 3, contourPaint);
        }
      }
    }

    for (var point in points) {
      final offset = toOffset(point.x1, point.x2);
      final color = point.target == 1 ? Colors.cyanAccent : Colors.redAccent;

      canvas.drawCircle(offset, 26, Paint()..color = color.withOpacity(0.9));
      canvas.drawCircle(offset, 26, Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6);
      canvas.drawCircle(offset, 16, Paint()..color = color);
      canvas.drawCircle(offset, 6, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant DecisionBoundaryPainter old) {
    return old.w1 != w1 ||
        old.w2 != w2 ||
        old.w0 != w0 ||
        old.isXor != isXor ||
        old.points.length != points.length;
  }
}
