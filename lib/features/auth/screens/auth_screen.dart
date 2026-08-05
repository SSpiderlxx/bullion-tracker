import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.darkBackground, Color(0xFF1A1A24)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.gold.withValues(alpha: 0.2), AppColors.goldAccent.withValues(alpha: 0.05)],
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/bullion_logo.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.shield, size: 80, color: AppColors.gold),
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 32),
                  const Text('Bullion Tracker', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  const Text('Track your precious metals portfolio', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.darkTextSecondary)).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  const Spacer(flex: 2),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _AuthButton(icon: Icons.apple, text: 'Sign in with Apple', onPressed: () {}, backgroundColor: Colors.white, textColor: Colors.black),
                        const SizedBox(height: 12),
                        _AuthButton(icon: Icons.g_mobiledata, text: 'Sign in with Google', onPressed: () {}, backgroundColor: AppColors.darkSurface, textColor: Colors.white),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Continue as Guest', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 32),
                  const Text('By continuing, you agree to our Terms of Service\nand Privacy Policy.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary)).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const _AuthButton({required this.icon, required this.text, required this.onPressed, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, foregroundColor: textColor, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
