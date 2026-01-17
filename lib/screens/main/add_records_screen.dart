import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../records/fbs_records_screen.dart';
import '../records/blood_pressure_records_screen.dart';
import '../records/fbc_records_screen.dart';
import '../records/lipid_profile_records_screen.dart';
import '../records/liver_profile_records_screen.dart';
import '../records/urine_report_records_screen.dart';

class AddRecordsScreen extends StatefulWidget {
  const AddRecordsScreen({super.key});

  @override
  State<AddRecordsScreen> createState() => _AddRecordsScreenState();
}

class _AddRecordsScreenState extends State<AddRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      appBar: CustomAppBar(
        title: 'Health Records',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelStyle: AppTypography.labelLarge,
              unselectedLabelStyle: AppTypography.labelMedium,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              tabs: const [
                Tab(text: 'Blood Sugar'),
                Tab(text: 'Blood Pressure'),
                Tab(text: 'Blood Count'),
                Tab(text: 'Lipid Profile'),
                Tab(text: 'Liver Profile'),
                Tab(text: 'Urine Report'),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FbsRecordsScreen(),
                BloodPressureRecordsScreen(),
                FbcRecordsScreen(),
                LipidProfileRecordsScreen(),
                LiverProfileRecordsScreen(),
                UrineReportRecordsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
