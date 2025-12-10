import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../widgets/health_summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
            return const Center(
              child: Text('No user data available'),
            );
          }

          if (healthProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
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
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Health summary cards
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
                        color: Colors.red,
                        latestValue: healthProvider.bpRecords.isNotEmpty
                            ? '${healthProvider.bpRecords.last.systolic}/${healthProvider.bpRecords.last.diastolic}'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Blood Sugar',
                        count: healthProvider.fbsRecords.length,
                        icon: Icons.bloodtype,
                        color: Colors.orange,
                        latestValue: healthProvider.fbsRecords.isNotEmpty
                            ? '${healthProvider.fbsRecords.last.fbsLevel.toStringAsFixed(1)} mg/dL'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Full Blood Count',
                        count: healthProvider.fbcRecords.length,
                        icon: Icons.science,
                        color: Colors.purple,
                        latestValue: healthProvider.fbcRecords.isNotEmpty
                            ? 'Hb: ${healthProvider.fbcRecords.last.hemoglobin.toStringAsFixed(1)} g/dL'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Lipid Profile',
                        count: healthProvider.lipidRecords.length,
                        icon: Icons.monitor_heart,
                        color: Colors.green,
                        latestValue: healthProvider.lipidRecords.isNotEmpty
                            ? 'TC: ${healthProvider.lipidRecords.last.totalCholesterol.toStringAsFixed(1)}'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Liver Profile',
                        count: healthProvider.liverRecords.length,
                        icon: Icons.local_hospital,
                        color: Colors.amber,
                        latestValue: healthProvider.liverRecords.isNotEmpty
                            ? 'ALT: ${healthProvider.liverRecords.last.alt.toStringAsFixed(1)}'
                            : 'No data',
                      ),
                      HealthSummaryCard(
                        title: 'Urine Report',
                        count: healthProvider.urineRecords.length,
                        icon: Icons.water_drop,
                        color: Colors.blue,
                        latestValue: healthProvider.urineRecords.isNotEmpty
                            ? 'pH: ${healthProvider.urineRecords.last.ph.toStringAsFixed(1)}'
                            : 'No data',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Reports Section
                  const Text(
                    'Recent Reports',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                          leading: const Icon(
                            Icons.description,
                            color: Colors.blue,
                          ),
                          title: Text(report.summary ?? 'Health Report'),
                          subtitle: const Text('Comprehensive health analysis'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Handle report tap
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
}
