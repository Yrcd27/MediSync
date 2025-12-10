import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/health_records_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<HealthRecordsProvider>(
          builder: (context, healthProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blood Sugar Trends
                _buildChartSection(
                  'Blood Sugar Trends',
                  Icons.bloodtype,
                  Colors.orange,
                  _buildFBSChart(healthProvider),
                ),

                const SizedBox(height: 24),

                // Blood Pressure Trends
                _buildChartSection(
                  'Blood Pressure Trends',
                  Icons.favorite,
                  Colors.red,
                  _buildBPChart(healthProvider),
                ),

                const SizedBox(height: 24),

                // Statistics Cards
                const Text(
                  'Health Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      'Avg FBS',
                      _calculateAvgFBS(healthProvider),
                      'mg/dL',
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Latest BP',
                      _getLatestBP(healthProvider),
                      'mmHg',
                      Colors.red,
                    ),
                    _buildStatCard(
                      'Total Records',
                      _getTotalRecords(healthProvider).toString(),
                      'entries',
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'This Month',
                      _getThisMonthRecords(healthProvider).toString(),
                      'new records',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartSection(
      String title, IconData icon, Color color, Widget chart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFBSChart(HealthRecordsProvider provider) {
    if (provider.fbsRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No blood sugar data available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final spots = provider.fbsRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.fbsLevel);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBPChart(HealthRecordsProvider provider) {
    if (provider.bpRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No blood pressure data available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final systolicSpots = provider.bpRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
    }).toList();

    final diastolicSpots = provider.bpRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: systolicSpots,
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: diastolicSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAvgFBS(HealthRecordsProvider provider) {
    if (provider.fbsRecords.isEmpty) return '--';
    final total = provider.fbsRecords
        .fold<double>(0, (sum, record) => sum + record.fbsLevel);
    return (total / provider.fbsRecords.length).toStringAsFixed(1);
  }

  String _getLatestBP(HealthRecordsProvider provider) {
    if (provider.bpRecords.isEmpty) return '--/--';
    final latest = provider.bpRecords.last;
    return '${latest.systolic}/${latest.diastolic}';
  }

  int _getTotalRecords(HealthRecordsProvider provider) {
    return provider.fbsRecords.length +
        provider.bpRecords.length +
        provider.fbcRecords.length +
        provider.lipidRecords.length +
        provider.liverRecords.length +
        provider.urineRecords.length;
  }

  int _getThisMonthRecords(HealthRecordsProvider provider) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);

    int count = 0;

    // Count FBS records from this month
    count += provider.fbsRecords.where((record) {
      final recordDate = DateTime.parse(record.testDate);
      return recordDate.isAfter(thisMonth);
    }).length;

    // Count BP records from this month
    count += provider.bpRecords.where((record) {
      final recordDate = DateTime.parse(record.testDate);
      return recordDate.isAfter(thisMonth);
    }).length;

    return count;
  }
}
