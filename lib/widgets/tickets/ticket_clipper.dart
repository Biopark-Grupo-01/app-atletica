import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  final double imageWidth;
  TicketClipper({required this.imageWidth});

  @override
  Path getClip(Size size) {
    const double cornerRadius = 12;
    const double notchWidth = 8;
    const double notchHeight = 16;

    final base =
        Path()
          ..moveTo(0, cornerRadius)
          ..quadraticBezierTo(0, 0, cornerRadius, 0)
          ..lineTo(size.width - cornerRadius, 0)
          ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
          ..lineTo(size.width, size.height / 2 - cornerRadius)
          ..arcToPoint(
            Offset(size.width, size.height / 2 + cornerRadius),
            radius: const Radius.circular(cornerRadius),
            clockwise: false,
          )
          ..lineTo(size.width, size.height - cornerRadius)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - cornerRadius,
            size.height,
          )
          ..lineTo(cornerRadius, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height - cornerRadius)
          ..close();

    final topCut =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(imageWidth, 0),
              width: notchWidth,
              height: notchHeight,
            ),
            const Radius.circular(4),
          ),
        );
    final bottomCut =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(imageWidth, size.height),
              width: notchWidth,
              height: notchHeight,
            ),
            const Radius.circular(4),
          ),
        );

    return Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, base, topCut),
      bottomCut,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
