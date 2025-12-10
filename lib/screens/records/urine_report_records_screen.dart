import 'package:flutter/material.dart';

class UrineReportRecordsScreen extends StatelessWidget {
  const UrineReportRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.water_drop, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Urine Report Records',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Monitor urine analysis including\nColor, pH, Protein, Glucose, and more',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
