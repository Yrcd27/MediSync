import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/full_blood_count.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/health_analysis.dart';

class FBCRecordsScreen extends StatefulWidget {
  const FBCRecordsScreen({super.key});

  @override
  State<FBCRecordsScreen> createState() => _FBCRecordsScreenState();
}

class _FBCRecordsScreenState extends State<FBCRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _haemoglobinController = TextEditingController();
  final _wbcController = TextEditingController();
  final _plateletController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _haemoglobinController.dispose();
    _wbcController.dispose();
    _plateletController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _testDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _addRecord() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final healthProvider = context.read<HealthRecordsProvider>();

      if (authProvider.currentUser == null) return;

      final record = FullBloodCount(
        id: 0,
        testDate: _testDateController.text,
        haemoglobin: double.parse(_haemoglobinController.text),
        totalLeucocyteCount: double.parse(_wbcController.text),
        plateletCount: double.parse(_plateletController.text),
        imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      );

      final success = await healthProvider.addFBCRecord(
          record, authProvider.currentUser!.id);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('FBC record added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          _haemoglobinController.clear();
          _wbcController.clear();
          _plateletController.clear();
          _imageUrlController.clear();
          _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(healthProvider.errorMessage ?? 'Error adding record'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Add Full Blood Count Record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _testDateController,
                          label: 'Test Date',
                          hint: 'Select test date',
                          suffixIcon: const Icon(Icons.calendar_today),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select test date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _haemoglobinController,
                      label: 'Haemoglobin (g/dL)',
                      hint: 'e.g., 14.5',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 1 || val > 25) return 'Invalid (1-25)';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _wbcController,
                      label: 'WBC Count (cells/mcL)',
                      hint: 'e.g., 7500',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 1000 || val > 50000) return 'Invalid (1000-50000)';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _plateletController,
                      label: 'Platelet Count (cells/mcL)',
                      hint: 'e.g., 250000',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 10000 || val > 1000000) return 'Invalid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _imageUrlController,
                      label: 'Report Image URL (Optional)',
                      hint: 'Enter image URL or file path',
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Add Record',
                      onPressed: _addRecord,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Consumer<HealthRecordsProvider>(
              builder: (context, healthProvider, child) {
                if (healthProvider.fbcRecords.isEmpty) {
                  return const Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.science_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No FBC records yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: healthProvider.fbcRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .fbcRecords[healthProvider.fbcRecords.length - 1 - index];
                    final hbAnalysis = HealthAnalysis.analyzeHaemoglobin(
                        record.haemoglobin, user?.gender ?? 'male');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: hbAnalysis.color,
                          child: const Icon(Icons.science, color: Colors.white),
                        ),
                        title: Text(
                          'Hb: ${record.haemoglobin.toStringAsFixed(1)} g/dL',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Date: ${record.testDate}'),
                        children: [
                          ListTile(
                            title: const Text('WBC Count'),
                            trailing: Text('${record.totalLeucocyteCount.toStringAsFixed(0)} /mcL'),
                          ),
                          ListTile(
                            title: const Text('Platelet Count'),
                            trailing: Text('${record.plateletCount.toStringAsFixed(0)} /mcL'),
                          ),
                          ListTile(
                            title: const Text('Status'),
                            trailing: Text(
                              hbAnalysis.statusText,
                              style: TextStyle(color: hbAnalysis.color, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Record'),
                                      content: const Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await healthProvider.deleteFBCRecord(record.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
