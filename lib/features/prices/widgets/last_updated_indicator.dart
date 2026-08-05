import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class LastUpdatedIndicator extends StatelessWidget {
  const LastUpdatedIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would format a DateTime and show countdown
    // Here we use static text for presentation
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.profit,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.profit,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Live Prices • Updates in 45s',
              style: GoogleFonts.inter(
                color: AppColors.textSecondaryDark ?? Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
