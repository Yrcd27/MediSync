import 'package:flutter/material.dart';
import '../../widgets/common/custom_bottom_nav_bar.dart';
import '../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';
import 'records_hub_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RecordsHubScreen(),
    const AnalyticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
          ),
          BottomNavItem(
            icon: Icons.folder_outlined,
            activeIcon: Icons.folder,
            label: 'Records',
          ),
          BottomNavItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
            label: 'Analytics',
          ),
          BottomNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
