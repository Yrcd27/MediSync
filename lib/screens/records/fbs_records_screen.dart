import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/fasting_blood_sugar.dart';

class FbsRecordsScreen extends StatefulWidget {
  const FbsRecordsScreen({super.key});

  @override
  State<FbsRecordsScreen> createState() => _FbsRecordsScreenState();
}

class _FbsRecordsScreenState extends State<FbsRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _fbsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _fbsController.dispose();
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
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final authProvider = context.read<AuthProvider>();
        final healthProvider = context.read<HealthRecordsProvider>();

        if (authProvider.currentUser == null) return;

        final record = FastingBloodSugar(
          id: 0,
          testDate: _testDateController.text,
          fbsLevel: double.parse(_fbsController.text),
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addFBSRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('FBS record added successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            _fbsController.clear();
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
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.02,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Add Fasting Blood Sugar Record',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                          ),
                          const SizedBox(height: 12),

                          InkWell(
                            onTap: _selectDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Test Date',
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                _testDateController.text,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _fbsController,
                            decoration: InputDecoration(
                              labelText: 'Fasting Blood Sugar (mg/dL)',
                              hintText: '90',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 30 || val > 400)
                                return 'Invalid range';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(
                              labelText: 'Report Image (Optional)',
                              hintText: 'URL or file path',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _addRecord,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Add Record',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Consumer<HealthRecordsProvider>(
                  builder: (context, healthProvider, child) {
                    if (healthProvider.fbsRecords.isEmpty) {
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No records yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: healthProvider.fbsRecords.length,
                      itemBuilder: (context, index) {
                        final record =
                            healthProvider.fbsRecords[healthProvider
                                    .fbsRecords
                                    .length -
                                1 -
                                index];
                        return _buildCompactRecordCard(record);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactRecordCard(FastingBloodSugar record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: _getFBSColor(record.fbsLevel),
          child: const Icon(Icons.water_drop, color: Colors.white, size: 16),
        ),
        title: Text(
          '${record.fbsLevel.toStringAsFixed(1)} mg/dL',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getFBSColor(record.fbsLevel).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _getFBSStatus(record.fbsLevel),
            style: TextStyle(
              color: _getFBSColor(record.fbsLevel),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Color _getFBSColor(double fbs) {
    if (fbs < 100) return Colors.green;
    if (fbs < 126) return Colors.orange;
    return Colors.red;
  }

  String _getFBSStatus(double fbs) {
    if (fbs < 100) return 'Normal';
    if (fbs < 126) return 'Pre-diabetic';
    return 'Diabetic';
  }
}
