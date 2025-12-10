import 'package:flutter/material.dart';

class LipidProfileRecordsScreen extends StatelessWidget {
  const LipidProfileRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monitor_heart, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Lipid Profile Records',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Monitor your cholesterol levels including\nTotal Cholesterol, HDL, LDL, and Triglycerides',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
