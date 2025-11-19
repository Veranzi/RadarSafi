import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RadarLogo extends StatelessWidget {
  const RadarLogo({super.key, this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _RadarLogoPainter());
  }
}

class _RadarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = AppColors.accentGreen.withOpacity(0.9);

    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(center, radius - (i * 20), paint);
    }

    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = AppColors.accentBlue;

    final sweepPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + radius - 12, center.dy - 8);
    canvas.drawPath(sweepPath, sweepPaint);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accentGreen;
    canvas.drawCircle(center, 8, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
