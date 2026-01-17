import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/urine_report.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/health_analysis.dart';

class UrineReportRecordsScreen extends StatefulWidget {
  const UrineReportRecordsScreen({super.key});

  @override
  State<UrineReportRecordsScreen> createState() =>
      _UrineReportRecordsScreenState();
}

class _UrineReportRecordsScreenState extends State<UrineReportRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _specificGravityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedColor = 'Pale Yellow';
  String _selectedAppearance = 'Clear';
  String _selectedProtein = 'Negative';
  String _selectedSugar = 'Negative';

  final List<String> _colorOptions = [
    'Pale Yellow',
    'Yellow',
    'Dark Yellow',
    'Amber',
    'Red',
    'Brown',
    'Clear',
  ];

  final List<String> _appearanceOptions = [
    'Clear',
    'Slightly Cloudy',
    'Cloudy',
    'Turbid',
  ];

  final List<String> _proteinOptions = [
    'Negative',
    'Trace',
    '+',
    '++',
    '+++',
    '++++',
  ];

  final List<String> _sugarOptions = [
    'Negative',
    'Trace',
    '+',
    '++',
    '+++',
    '++++',
  ];

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _specificGravityController.text = '1.020'; // Normal default
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _specificGravityController.dispose();
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

      final record = UrineReport(
        id: 0,
        testDate: _testDateController.text,
        color: _selectedColor,
        appearance: _selectedAppearance,
        protein: _selectedProtein,
        sugar: _selectedSugar,
        specificGravity: double.parse(_specificGravityController.text),
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
      );

      final success = await healthProvider.addUrineRecord(
        record,
        authProvider.currentUser!.id,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Urine report record added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset to defaults
          _selectedColor = 'Pale Yellow';
          _selectedAppearance = 'Clear';
          _selectedProtein = 'Negative';
          _selectedSugar = 'Negative';
          _specificGravityController.text = '1.020';
          _imageUrlController.clear();
          _testDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.now());
          setState(() {});
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select $label' : null,
    );
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
                      'Add Urine Report Record',
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
                          child: _buildDropdownField(
                            label: 'Color',
                            value: _selectedColor,
                            options: _colorOptions,
                            onChanged: (value) =>
                                setState(() => _selectedColor = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Appearance',
                            value: _selectedAppearance,
                            options: _appearanceOptions,
                            onChanged: (value) =>
                                setState(() => _selectedAppearance = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Protein',
                            value: _selectedProtein,
                            options: _proteinOptions,
                            onChanged: (value) =>
                                setState(() => _selectedProtein = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Sugar',
                            value: _selectedSugar,
                            options: _sugarOptions,
                            onChanged: (value) =>
                                setState(() => _selectedSugar = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _specificGravityController,
                      label: 'Specific Gravity',
                      hint: 'e.g., 1.020 (Normal: 1.005-1.030)',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 1.000 || val > 1.050)
                          return 'Invalid (1.000-1.050)';
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
                if (healthProvider.urineRecords.isEmpty) {
                  return const Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No urine report records yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: healthProvider.urineRecords.length,
                  itemBuilder: (context, index) {
                    final record =
                        healthProvider.urineRecords[healthProvider
                                .urineRecords
                                .length -
                            1 -
                            index];
                    final sgAnalysis = HealthAnalysis.analyzeSpecificGravity(
                      record.specificGravity,
                    );

                    // Determine overall status color based on abnormal findings
                    Color statusColor = Colors.green;
                    if (record.protein != 'Negative' ||
                        record.sugar != 'Negative' ||
                        sgAnalysis.color == Colors.red) {
                      statusColor = Colors.red;
                    } else if (sgAnalysis.color == Colors.orange) {
                      statusColor = Colors.orange;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor,
                          child: const Icon(
                            Icons.water_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'SG: ${record.specificGravity.toStringAsFixed(3)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Date: ${record.testDate}'),
                        children: [
                          ListTile(
                            title: const Text('Color'),
                            trailing: Text(record.color),
                          ),
                          ListTile(
                            title: const Text('Appearance'),
                            trailing: Text(record.appearance),
                          ),
                          ListTile(
                            title: const Text('Protein'),
                            trailing: Text(
                              record.protein,
                              style: TextStyle(
                                color: record.protein == 'Negative'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('Sugar'),
                            trailing: Text(
                              record.sugar,
                              style: TextStyle(
                                color: record.sugar == 'Negative'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('Specific Gravity Status'),
                            trailing: Text(
                              sgAnalysis.statusText,
                              style: TextStyle(
                                color: sgAnalysis.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              sgAnalysis.recommendation,
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
                                    await healthProvider.deleteUrineRecord(
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
