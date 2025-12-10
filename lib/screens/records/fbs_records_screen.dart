import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/fasting_blood_sugar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class FBSRecordsScreen extends StatefulWidget {
  const FBSRecordsScreen({super.key});

  @override
  State<FBSRecordsScreen> createState() => _FBSRecordsScreenState();
}

class _FBSRecordsScreenState extends State<FBSRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fbsLevelController = TextEditingController();
  final _testDateController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _fbsLevelController.dispose();
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

      final record = FastingBloodSugar(
        id: 0, // Will be assigned by backend
        testDate: _testDateController.text,
        fbsLevel: double.parse(_fbsLevelController.text),
        imageUrl:
            _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        user: authProvider.currentUser!,
      );

      try {
        await healthProvider.addFBSRecord(record, authProvider.currentUser!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('FBS record added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear form
          _fbsLevelController.clear();
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
                      'Add FBS Record',
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
                    CustomTextField(
                      controller: _fbsLevelController,
                      label: 'FBS Level (mg/dL)',
                      hint: 'Enter FBS level',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter FBS level';
                        }
                        final level = double.tryParse(value);
                        if (level == null || level <= 0 || level > 1000) {
                          return 'Please enter a valid FBS level (0-1000)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _imageUrlController,
                      label: 'Report Image URL (Optional)',
                      hint: 'Enter image URL or file path',
                      validator: (value) {
                        // Optional field, no validation needed
                        return null;
                      },
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
                if (healthProvider.fbsRecords.isEmpty) {
                  return const Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bloodtype_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No FBS records yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first blood sugar reading above',
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
                  itemCount: healthProvider.fbsRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider.fbsRecords[
                        healthProvider.fbsRecords.length - 1 - index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getFBSColor(record.fbsLevel),
                          child: const Icon(
                            Icons.bloodtype,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${record.fbsLevel.toStringAsFixed(1)} mg/dL',
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
                              _getFBSStatus(record.fbsLevel),
                              style: TextStyle(
                                color: _getFBSColor(record.fbsLevel),
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

  Color _getFBSColor(double level) {
    if (level < 70) return Colors.blue; // Low
    if (level <= 100) return Colors.green; // Normal
    if (level <= 125) return Colors.orange; // Prediabetes
    return Colors.red; // Diabetes
  }

  String _getFBSStatus(double level) {
    if (level < 70) return 'Low';
    if (level <= 100) return 'Normal';
    if (level <= 125) return 'Prediabetes';
    return 'High';
  }

  void _editRecord(FastingBloodSugar record) {
    // Implement edit functionality
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
