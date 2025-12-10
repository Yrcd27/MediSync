import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
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
      body: TabBarView(
        controller: _tabController,
        children: const [
          FBSRecordsScreen(),
          BloodPressureRecordsScreen(),
          FBCRecordsScreen(),
          LipidProfileRecordsScreen(),
          LiverProfileRecordsScreen(),
          UrineReportRecordsScreen(),
        ],
      ),
    );
  }
}
