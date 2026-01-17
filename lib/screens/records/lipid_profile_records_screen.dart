import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/lipid_profile.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/health_analysis.dart';

class LipidProfileRecordsScreen extends StatefulWidget {
  const LipidProfileRecordsScreen({super.key});

  @override
  State<LipidProfileRecordsScreen> createState() =>
      _LipidProfileRecordsScreenState();
}

class _LipidProfileRecordsScreenState extends State<LipidProfileRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _totalCholesterolController = TextEditingController();
  final _hdlController = TextEditingController();
  final _ldlController = TextEditingController();
  final _vldlController = TextEditingController();
  final _triglyceridesController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _totalCholesterolController.dispose();
    _hdlController.dispose();
    _ldlController.dispose();
    _vldlController.dispose();
    _triglyceridesController.dispose();
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

      final record = LipidProfile(
        id: 0,
        testDate: _testDateController.text,
        totalCholesterol: double.parse(_totalCholesterolController.text),
        hdl: double.parse(_hdlController.text),
        ldl: double.parse(_ldlController.text),
        vldl: double.parse(_vldlController.text),
        triglycerides: double.parse(_triglyceridesController.text),
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
      );

      final success = await healthProvider.addLipidRecord(
        record,
        authProvider.currentUser!.id,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lipid profile record added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          _totalCholesterolController.clear();
          _hdlController.clear();
          _ldlController.clear();
          _vldlController.clear();
          _triglyceridesController.clear();
          _imageUrlController.clear();
          _testDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.now());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                healthProvider.errorMessage ?? 'Error adding record',
              ),
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
                      'Add Lipid Profile Record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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
                            controller: _totalCholesterolController,
                            label: 'Total Cholesterol (mg/dL)',
                            hint: 'e.g., 200',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 50 || val > 800)
                                return 'Invalid (50-800)';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _hdlController,
                            label: 'HDL (mg/dL)',
                            hint: 'e.g., 45',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 10 || val > 150)
                                return 'Invalid (10-150)';
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
                            controller: _ldlController,
                            label: 'LDL (mg/dL)',
                            hint: 'e.g., 130',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 20 || val > 500)
                                return 'Invalid (20-500)';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _vldlController,
                            label: 'VLDL (mg/dL)',
                            hint: 'e.g., 25',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 5 || val > 100)
                                return 'Invalid (5-100)';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _triglyceridesController,
                      label: 'Triglycerides (mg/dL)',
                      hint: 'e.g., 150',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 30 || val > 1000)
                          return 'Invalid (30-1000)';
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
                    CustomButton(text: 'Add Record', onPressed: _addRecord),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Consumer<HealthRecordsProvider>(
              builder: (context, healthProvider, child) {
                if (healthProvider.lipidRecords.isEmpty) {
                  return const Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monitor_heart_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No lipid profile records yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: healthProvider.lipidRecords.length,
                  itemBuilder: (context, index) {
                    final record =
                        healthProvider.lipidRecords[healthProvider
                                .lipidRecords
                                .length -
                            1 -
                            index];
                    final cholesterolAnalysis =
                        HealthAnalysis.analyzeTotalCholesterol(
                          record.totalCholesterol,
                        );
                    final user = context.read<AuthProvider>().currentUser;
                    final hdlAnalysis = HealthAnalysis.analyzeHDL(
                      record.hdl,
                      user?.gender ?? 'male',
                    );
                    final ldlAnalysis = HealthAnalysis.analyzeLDL(record.ldl);
                    final triglyceridesToolAnalysis =
                        HealthAnalysis.analyzeTriglycerides(
                          record.triglycerides,
                        );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: cholesterolAnalysis.color,
                          child: const Icon(
                            Icons.monitor_heart,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'TC: ${record.totalCholesterol.toStringAsFixed(0)} mg/dL',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Date: ${record.testDate}'),
                        children: [
                          ListTile(
                            title: const Text('HDL (Good)'),
                            trailing: Text(
                              '${record.hdl.toStringAsFixed(0)} mg/dL',
                              style: TextStyle(
                                color: hdlAnalysis.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('LDL (Bad)'),
                            trailing: Text(
                              '${record.ldl.toStringAsFixed(0)} mg/dL',
                              style: TextStyle(
                                color: ldlAnalysis.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('VLDL'),
                            trailing: Text(
                              '${record.vldl.toStringAsFixed(0)} mg/dL',
                            ),
                          ),
                          ListTile(
                            title: const Text('Triglycerides'),
                            trailing: Text(
                              '${record.triglycerides.toStringAsFixed(0)} mg/dL',
                              style: TextStyle(
                                color: triglyceridesToolAnalysis.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('Overall Status'),
                            trailing: Text(
                              cholesterolAnalysis.statusText,
                              style: TextStyle(
                                color: cholesterolAnalysis.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              cholesterolAnalysis.recommendation,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Record'),
                                      content: const Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await healthProvider.deleteLipidRecord(
                                      record.id,
                                    );
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
