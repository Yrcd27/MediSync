import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../screens/records/add/add_blood_pressure_screen.dart';
import '../../screens/records/add/add_blood_sugar_screen.dart';
import '../../screens/records/add/add_blood_count_screen.dart';
import '../../screens/records/add/add_lipid_profile_screen.dart';
import '../../screens/records/add/add_liver_profile_screen.dart';
import '../../screens/records/add/add_urine_report_screen.dart';

class RecordTypeSelector extends StatelessWidget {
  const RecordTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              borderRadius: AppSpacing.borderRadiusFull,
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  'Select Record Type',
                  style: AppTypography.title1.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Grid of options
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.4,
              children: [
                _buildTypeCard(
                  context,
                  title: 'Blood Pressure',
                  subtitle: 'Systolic & Diastolic',
                  icon: Icons.favorite_rounded,
                  color: AppColors.bloodPressure,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddBloodPressureScreen()),
                    );
                  },
                  isDark: isDark,
                ),
                _buildTypeCard(
                  context,
                  title: 'Blood Sugar',
                  subtitle: 'Fasting glucose',
                  icon: Icons.water_drop_rounded,
                  color: AppColors.bloodSugar,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddBloodSugarScreen()),
                    );
                  },
                  isDark: isDark,
                ),
                _buildTypeCard(
                  context,
                  title: 'Blood Count',
                  subtitle: 'CBC / FBC',
                  icon: Icons.science_rounded,
                  color: AppColors.bloodCount,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddBloodCountScreen()),
                    );
                  },
                  isDark: isDark,
                ),
                _buildTypeCard(
                  context,
                  title: 'Lipid Profile',
                  subtitle: 'Cholesterol levels',
                  icon: Icons.monitor_heart_rounded,
                  color: AppColors.lipidProfile,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddLipidProfileScreen()),
                    );
                  },
                  isDark: isDark,
                ),
                _buildTypeCard(
                  context,
                  title: 'Liver Profile',
                  subtitle: 'LFT results',
                  icon: Icons.local_hospital_rounded,
                  color: AppColors.liverProfile,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddLiverProfileScreen()),
                    );
                  },
                  isDark: isDark,
                ),
                _buildTypeCard(
                  context,
                  title: 'Urine Report',
                  subtitle: 'Urinalysis',
                  icon: Icons.opacity_rounded,
                  color: AppColors.urineReport,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddUrineReportScreen()),
                    );
                  },
                  isDark: isDark,
                ),
              ],
            ),
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.title3.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
