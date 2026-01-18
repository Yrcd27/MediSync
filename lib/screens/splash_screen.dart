import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A5A9E), // Darker blue top
              const Color(0xFF2D7DD2), // Primary blue
              const Color(0xFF45B7D1), // Secondary cyan bottom
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background floating particles
            _buildBackgroundParticles(context),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedLogo(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildAnimatedTitle(),
                  const SizedBox(height: AppSpacing.md),
                  _buildAnimatedTagline(),
                  const SizedBox(height: AppSpacing.xxxl),
                  _buildCustomLoader(),
                ],
              ),
            ),

            // Version number at bottom
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  /// Animated logo with fade, scale, shimmer, and heartbeat pulse
  Widget _buildAnimatedLogo() {
    return Image.asset(
          'assets/images/heart-rate.png',
          width: AppSpacing.splashLogoSize,
          height: AppSpacing.splashLogoSize,
          color: Colors.white,
        )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.easeOut,
        )
        .then(delay: 200.ms)
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.3))
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: 800.ms,
          curve: Curves.easeInOut,
        );
  }

  /// App name with fade and slide animation
  Widget _buildAnimatedTitle() {
    return Text(
          'MediSync',
          style: AppTypography.headline1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 500.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.3,
          end: 0,
          delay: 400.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }

  /// Tagline with fade and slide animation
  Widget _buildAnimatedTagline() {
    return Padding(
          padding: AppSpacing.paddingHorizontalXl,
          child: Text(
            'Smart Personal Health Record Tracker',
            style: AppTypography.body1.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        )
        .animate()
        .fadeIn(delay: 700.ms, duration: 500.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.2,
          end: 0,
          delay: 700.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }

  /// Custom pulsing dots loader
  Widget _buildCustomLoader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppSpacing.splashDotSpacing / 2,
          ),
          child:
              Container(
                    width: AppSpacing.splashDotSize,
                    height: AppSpacing.splashDotSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    delay: Duration(milliseconds: index * 200),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(0.5, 0.5),
                    duration: 600.ms,
                  ),
        );
      }),
    ).animate().fadeIn(delay: 1000.ms, duration: 400.ms);
  }

  /// Version info at bottom
  Widget _buildVersionInfo() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child:
          Text(
            'v1.0.0',
            style: AppTypography.caption.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
            delay: 1200.ms,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  /// Floating background particles for depth
  Widget _buildBackgroundParticles(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: List.generate(8, (index) {
        // Distribute particles across the screen
        final leftPosition =
            (index % 4) * (screenWidth / 4) + (screenWidth / 8);
        final topPosition =
            (index ~/ 4) * (screenHeight / 2) + (screenHeight / 4);

        return Positioned(
          left: leftPosition,
          top: topPosition,
          child:
              Icon(
                    index % 2 == 0 ? Icons.favorite_border : Icons.add,
                    color: Colors.white.withOpacity(0.08),
                    size: 24 + (index % 3) * 8.0,
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .moveY(
                    begin: 0,
                    end: -50,
                    duration: Duration(seconds: 3 + (index % 3)),
                    curve: Curves.easeInOut,
                  )
                  .fadeOut(
                    delay: Duration(milliseconds: 2000 + (index * 100)),
                    duration: 1000.ms,
                  )
                  .then()
                  .fadeIn(duration: 1000.ms),
        );
      }),
    );
  }
}
