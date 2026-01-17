import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.05),
              AppColors.background,
              AppColors.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom Pulse Mark (ECG waveform)
              CustomPaint(
                size: const Size(200, 80),
                painter: PulseMarkPainter(),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // App Name
              Text(
                'MediSync',
                style: AppTypography.headline1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Smart Personal Health Record Tracker',
                style: AppTypography.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PulseMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
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
