import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_widgets.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  double? _bmi;
  String? _category;
  double? _waterLitres;
  int? _calorieEstimate;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final heightCm = double.parse(_heightController.text);
    final weightKg = double.parse(_weightController.text);
    final age = int.tryParse(_ageController.text) ?? 30;

    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);

    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    // Standard water intake estimate: ~35ml per kg body weight.
    final water = (weightKg * 0.035);

    // Simplified Mifflin-St Jeor estimate (assumes average activity, male defaults).
    final calories = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;

    setState(() {
      _bmi = bmi;
      _category = category;
      _waterLitres = water;
      _calorieEstimate = calories.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI & Calculators')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafetyDisclaimerBanner(
                  message:
                      'These calculators provide general estimates for educational purposes '
                      'and are not a substitute for professional medical or dietary advice.',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _heightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (v) => Validators.numeric(v, field: 'Height'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                  validator: (v) => Validators.numeric(v, field: 'Weight'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age (years)',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  validator: (v) => Validators.numeric(v, field: 'Age'),
                ),
                const SizedBox(height: 24),
                PrimaryButton(label: 'Calculate', onPressed: _calculate),
                if (_bmi != null) ...[
                  const SizedBox(height: 28),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Results',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        _ResultRow(
                            label: 'BMI', value: _bmi!.toStringAsFixed(1)),
                        _ResultRow(label: 'Category', value: _category!),
                        _ResultRow(
                            label: 'Daily Water Intake',
                            value:
                                '${_waterLitres!.toStringAsFixed(1)} L'),
                        _ResultRow(
                            label: 'Estimated Daily Calories',
                            value: '$_calorieEstimate kcal'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
