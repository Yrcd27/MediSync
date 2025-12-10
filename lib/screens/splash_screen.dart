import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Pulse Mark (ECG waveform)
            CustomPaint(
              size: const Size(200, 80),
              painter: PulseMarkPainter(),
            ),
            const SizedBox(height: 32),
            // App Name
            const Text(
              'MediSync',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Smart Personal Health Record Tracker',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class PulseMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Create ECG-like waveform
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // Start from left
    path.moveTo(0, centerY);

    // Flat line
    path.lineTo(width * 0.2, centerY);

    // First small peak
    path.lineTo(width * 0.25, centerY - height * 0.2);
    path.lineTo(width * 0.3, centerY);

    // Main spike
    path.lineTo(width * 0.4, centerY);
    path.lineTo(width * 0.45, centerY - height * 0.4);
    path.lineTo(width * 0.5, centerY + height * 0.3);
    path.lineTo(width * 0.55, centerY - height * 0.1);
    path.lineTo(width * 0.6, centerY);

    // Flat line and another smaller spike
    path.lineTo(width * 0.7, centerY);
    path.lineTo(width * 0.75, centerY - height * 0.15);
    path.lineTo(width * 0.8, centerY);

    // End flat line
    path.lineTo(width, centerY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
