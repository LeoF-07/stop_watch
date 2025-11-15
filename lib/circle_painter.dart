import 'dart:math';

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final int secondi;
  final bool paused;
  CirclePainter(this.secondi, this.paused);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint dotPaint = Paint()..color = paused ? Colors.yellow : Colors.blue;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Disegna la circonferenza
    canvas.drawCircle(center, radius, circlePaint);

    // Calcola angolo in base ai secondi
    final double angle = (2 * pi / 60) * (secondi % 60) - pi / 2;

    // Coordinate del pallino
    final double dx = center.dx + radius * cos(angle);
    final double dy = center.dy + radius * sin(angle);

    canvas.drawCircle(Offset(dx, dy), 8, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.secondi != secondi;
  }
}