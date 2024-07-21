import 'package:flutter/material.dart';

class CircularClipper extends CustomClipper<Path> {
  final double radius;

  CircularClipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();

    // Move to the top left corner of the rectangle
    path.moveTo(0, 0);

    // Draw the rectangle excluding the top center circle
    path.lineTo(size.width / 2 - radius, 0);
    path.arcToPoint(Offset(size.width / 2 + radius, 0),
        radius: Radius.circular(radius), clockwise: false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
