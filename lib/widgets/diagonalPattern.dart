import "package:flutter/material.dart";
import "dart:math" as math;

class DiagonalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    if (size.width > 0 && size.height > 0) {
      final double offset = 10.0;

      for (double i = -size.height; i < size.width + size.height; i += 15.0) {
        canvas.drawLine(
          Offset(i - size.height - offset, size.height + offset),
          Offset(i + offset, -offset),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

