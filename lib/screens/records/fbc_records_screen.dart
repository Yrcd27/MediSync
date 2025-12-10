import 'package:flutter/material.dart';

class FBCRecordsScreen extends StatelessWidget {
  const FBCRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science, size: 64, color: Colors.purple),
          SizedBox(height: 16),
          Text(
            'Full Blood Count Records',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Track your complete blood analysis including\nHemoglobin, WBC, RBC, and Platelets',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
