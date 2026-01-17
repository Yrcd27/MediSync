import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/liver_profile.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/health_analysis.dart';

class LiverProfileRecordsScreen extends StatefulWidget {
  const LiverProfileRecordsScreen({super.key});

  @override
  State<LiverProfileRecordsScreen> createState() => _LiverProfileRecordsScreenState();
}

class _LiverProfileRecordsScreenState extends State<LiverProfileRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _proteinController = TextEditingController();
  final _albuminController = TextEditingController();
  final _bilirubinController = TextEditingController();
  final _sgptController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _proteinController.dispose();
    _albuminController.dispose();
    _bilirubinController.dispose();
    _sgptController.dispose();
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

      final record = LiverProfile(
        id: 0,
        testDate: _testDateController.text,
        proteinTotalSerum: double.parse(_proteinController.text),
        albuminSerum: double.parse(_albuminController.text),
        bilirubinTotalSerum: double.parse(_bilirubinController.text),
        sgpt: double.parse(_sgptController.text),
        imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      );

      final success = await healthProvider.addLiverRecord(
          record, authProvider.currentUser!.id);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Liver profile record added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          _proteinController.clear();
          _albuminController.clear();
          _bilirubinController.clear();
          _sgptController.clear();
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
                      'Add Liver Profile Record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
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
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _proteinController,
                            label: 'Total Protein (g/dL)',
                            hint: 'e.g., 7.0',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 1 || val > 15) return 'Invalid (1-15)';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _albuminController,
                            label: 'Albumin (g/dL)',
                            hint: 'e.g., 4.0',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 0.5 || val > 8) return 'Invalid (0.5-8)';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _bilirubinController,
                            label: 'Bilirubin (mg/dL)',
                            hint: 'e.g., 0.8',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 0 || val > 30) return 'Invalid (0-30)';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _sgptController,
                            label: 'SGPT/ALT (U/L)',
                            hint: 'e.g., 35',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 0 || val > 1000) return 'Invalid (0-1000)';
                              return null;
                            },
                          ),
                        ),
                      ],
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
                if (healthProvider.liverRecords.isEmpty) {
                  return const Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_hospital_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No liver profile records yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: healthProvider.liverRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .liverRecords[healthProvider.liverRecords.length - 1 - index];
                    final sgptAnalysis = HealthAnalysis.analyzeSGPT(record.sgpt);
                    final bilirubinAnalysis = HealthAnalysis.analyzeBilirubin(record.bilirubinTotalSerum);
                    final albuminAnalysis = HealthAnalysis.analyzeAlbumin(record.albuminSerum);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: sgptAnalysis.color,
                          child: const Icon(Icons.local_hospital, color: Colors.white),
                        ),
                        title: Text(
                          'SGPT: ${record.sgpt.toStringAsFixed(1)} U/L',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Date: ${record.testDate}'),
                        children: [
                          ListTile(
                            title: const Text('Total Protein'),
                            trailing: Text('${record.proteinTotalSerum.toStringAsFixed(1)} g/dL'),
                          ),
                          ListTile(
                            title: const Text('Albumin'),
                            trailing: Text(
                              '${record.albuminSerum.toStringAsFixed(1)} g/dL',
                              style: TextStyle(color: albuminAnalysis.color),
                            ),
                          ),
                          ListTile(
                            title: const Text('Bilirubin'),
                            trailing: Text(
                              '${record.bilirubinTotalSerum.toStringAsFixed(2)} mg/dL',
                              style: TextStyle(color: bilirubinAnalysis.color),
                            ),
                          ),
                          ListTile(
                            title: const Text('SGPT Status'),
                            trailing: Text(
                              sgptAnalysis.statusText,
                              style: TextStyle(color: sgptAnalysis.color, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              sgptAnalysis.recommendation,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
                                    await healthProvider.deleteLiverRecord(record.id);
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
