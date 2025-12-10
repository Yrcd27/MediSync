import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/blood_pressure.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class BloodPressureRecordsScreen extends StatefulWidget {
  const BloodPressureRecordsScreen({super.key});

  @override
  State<BloodPressureRecordsScreen> createState() =>
      _BloodPressureRecordsScreenState();
}

class _BloodPressureRecordsScreenState
    extends State<BloodPressureRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _testDateController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _testDateController.dispose();
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

      final record = BloodPressure(
        id: 0, // Will be assigned by backend
        testDate: _testDateController.text,
        systolic: int.parse(_systolicController.text),
        diastolic: int.parse(_diastolicController.text),
        imageUrl:
            _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        user: authProvider.currentUser!,
      );

      try {
        await healthProvider.addBPRecord(record, authProvider.currentUser!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blood pressure record added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear form
          _systolicController.clear();
          _diastolicController.clear();
          _imageUrlController.clear();
          _testDateController.text =
              DateFormat('yyyy-MM-dd').format(DateTime.now());
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
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
          // Add Record Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Add Blood Pressure Record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
                            controller: _systolicController,
                            label: 'Systolic (mmHg)',
                            hint: 'e.g., 120',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final systolic = int.tryParse(value);
                              if (systolic == null ||
                                  systolic < 50 ||
                                  systolic > 300) {
                                return 'Invalid (50-300)';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _diastolicController,
                            label: 'Diastolic (mmHg)',
                            hint: 'e.g., 80',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final diastolic = int.tryParse(value);
                              if (diastolic == null ||
                                  diastolic < 30 ||
                                  diastolic > 200) {
                                return 'Invalid (30-200)';
                              }
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

          // Records List
          Expanded(
            child: Consumer<HealthRecordsProvider>(
              builder: (context, healthProvider, child) {
                if (healthProvider.bpRecords.isEmpty) {
                  return const Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No blood pressure records yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first blood pressure reading above',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: healthProvider.bpRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .bpRecords[healthProvider.bpRecords.length - 1 - index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _getBPColor(record.systolic, record.diastolic),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${record.systolic}/${record.diastolic} mmHg',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${record.testDate}'),
                            Text(
                              _getBPStatus(record.systolic, record.diastolic),
                              style: TextStyle(
                                color: _getBPColor(
                                    record.systolic, record.diastolic),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editRecord(record);
                            }
                          },
                        ),
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

  Color _getBPColor(int systolic, int diastolic) {
    if (systolic < 90 || diastolic < 60) return Colors.blue; // Low
    if (systolic < 120 && diastolic < 80) return Colors.green; // Normal
    if (systolic < 140 || diastolic < 90) return Colors.orange; // High Normal
    return Colors.red; // High
  }

  String _getBPStatus(int systolic, int diastolic) {
    if (systolic < 90 || diastolic < 60) return 'Low';
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 140 || diastolic < 90) return 'High Normal';
    return 'High';
  }

  void _editRecord(BloodPressure record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Record'),
        content: const Text('Edit functionality will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
