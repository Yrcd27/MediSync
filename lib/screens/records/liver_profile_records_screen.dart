import 'package:flutter/material.dart';

class LiverProfileRecordsScreen extends StatelessWidget {
  const LiverProfileRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_hospital, size: 64, color: Colors.amber),
          SizedBox(height: 16),
          Text(
            'Liver Profile Records',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Track your liver health with\nALT, AST, ALP, Bilirubin, and Albumin levels',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
