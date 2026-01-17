import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../widgets/health_summary_card.dart';
import '../../utils/health_analysis.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Records are already loaded by main_layout, no need to reload here
    // unless explicitly refreshed by user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) {
                context.read<HealthRecordsProvider>().loadAllRecords(user.id);
              }
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, HealthRecordsProvider>(
        builder: (context, authProvider, healthProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          if (healthProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await healthProvider.loadAllRecords(user.id);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, ${user.name}!',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Today is ${DateFormat('MMMM d, y').format(DateTime.now())}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats
                  const Text(
                    'Health Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Health summary cards - using correct model fields
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      HealthSummaryCard(
                        title: 'Blood Pressure',
                        count: healthProvider.bpRecords.length,
                        icon: Icons.favorite,
                        color: healthProvider.bpRecords.isNotEmpty
                            ? HealthAnalysis.analyzeBloodPressure(
                                healthProvider.bpRecords.last,
                              ).color
                            : Colors.red,
                        latestValue: healthProvider.bpRecords.isNotEmpty
                            ? healthProvider.bpRecords.last.bpLevel
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Blood Sugar',
                        count: healthProvider.fbsRecords.length,
                        icon: Icons.bloodtype,
                        color: healthProvider.fbsRecords.isNotEmpty
                            ? HealthAnalysis.analyzeFBS(
                                healthProvider.fbsRecords.last.fbsLevel,
                              ).color
                            : Colors.orange,
                        latestValue: healthProvider.fbsRecords.isNotEmpty
                            ? '${healthProvider.fbsRecords.last.fbsLevel.toStringAsFixed(1)} mg/dL'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Full Blood Count',
                        count: healthProvider.fbcRecords.length,
                        icon: Icons.science,
                        color: healthProvider.fbcRecords.isNotEmpty
                            ? HealthAnalysis.analyzeHaemoglobin(
                                healthProvider.fbcRecords.last.haemoglobin,
                                user.gender,
                              ).color
                            : Colors.purple,
                        latestValue: healthProvider.fbcRecords.isNotEmpty
                            ? 'Hb: ${healthProvider.fbcRecords.last.haemoglobin.toStringAsFixed(1)} g/dL'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Lipid Profile',
                        count: healthProvider.lipidRecords.length,
                        icon: Icons.monitor_heart,
                        color: healthProvider.lipidRecords.isNotEmpty
                            ? HealthAnalysis.analyzeTotalCholesterol(
                                healthProvider
                                    .lipidRecords
                                    .last
                                    .totalCholesterol,
                              ).color
                            : Colors.green,
                        latestValue: healthProvider.lipidRecords.isNotEmpty
                            ? 'TC: ${healthProvider.lipidRecords.last.totalCholesterol.toStringAsFixed(0)}'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Liver Profile',
                        count: healthProvider.liverRecords.length,
                        icon: Icons.local_hospital,
                        color: healthProvider.liverRecords.isNotEmpty
                            ? HealthAnalysis.analyzeSGPT(
                                healthProvider.liverRecords.last.sgpt,
                              ).color
                            : Colors.amber,
                        latestValue: healthProvider.liverRecords.isNotEmpty
                            ? 'SGPT: ${healthProvider.liverRecords.last.sgpt.toStringAsFixed(1)}'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Urine Report',
                        count: healthProvider.urineRecords.length,
                        icon: Icons.water_drop,
                        color: healthProvider.urineRecords.isNotEmpty
                            ? HealthAnalysis.analyzeSpecificGravity(
                                healthProvider
                                    .urineRecords
                                    .last
                                    .specificGravity,
                              ).color
                            : Colors.blue,
                        latestValue: healthProvider.urineRecords.isNotEmpty
                            ? 'SG: ${healthProvider.urineRecords.last.specificGravity.toStringAsFixed(3)}'
                            : 'No data',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Reports Section
                  const Text(
                    'Recent Reports',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (healthProvider.reports.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No reports available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add some health records to see comprehensive reports',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...healthProvider.reports.take(3).map((report) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              '${report.testCount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          title: Text(
                            'Report - ${report.reportDate}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            '${report.testCount} test(s) recorded',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            _showReportDetails(context, report);
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReportDetails(BuildContext context, dynamic report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              const Text(
                'Report Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${report.reportDate}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              if (report.bloodPressure != null)
                _buildDetailTile(
                  'Blood Pressure',
                  report.bloodPressure.bpLevel,
                ),
              if (report.fastingBloodSugar != null)
                _buildDetailTile(
                  'FBS',
                  '${report.fastingBloodSugar.fbsLevel.toStringAsFixed(1)} mg/dL',
                ),
              if (report.fullBloodCount != null)
                _buildDetailTile(
                  'Haemoglobin',
                  '${report.fullBloodCount.haemoglobin.toStringAsFixed(1)} g/dL',
                ),
              if (report.lipidProfile != null)
                _buildDetailTile(
                  'Total Cholesterol',
                  '${report.lipidProfile.totalCholesterol.toStringAsFixed(0)} mg/dL',
                ),
              if (report.liverProfile != null)
                _buildDetailTile(
                  'SGPT',
                  '${report.liverProfile.sgpt.toStringAsFixed(1)} U/L',
                ),
              if (report.urineReport != null)
                _buildDetailTile(
                  'Urine SG',
                  '${report.urineReport.specificGravity.toStringAsFixed(3)}',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
