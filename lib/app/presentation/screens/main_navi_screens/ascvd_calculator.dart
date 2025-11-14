import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class ASCVDCalculatorPage extends StatefulWidget {
  const ASCVDCalculatorPage({super.key});

  @override
  State<ASCVDCalculatorPage> createState() => _ASCVDCalculatorPageState();
}

class _ASCVDCalculatorPageState extends State<ASCVDCalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  // Input fields
  int age = 50;
  String sex = 'male';
  String race = 'white';
  double totalCholesterol = 200;
  double hdlCholesterol = 50;
  double systolicBP = 120;
  bool onHypertensionTreatment = false;
  bool smoker = false;
  bool diabetes = false;

  double? riskResult;
  List<String> warnings = [];

  @override
  void initState() {
    super.initState();
    validateInputs(); // Validate on initial load
  }

  void validateInputs() {
    setState(() {
      warnings.clear();
      
      // Check for unrealistic values
      if (age < 40  || age > 79) {
        warnings.add('Age should be between 40-79 years for accurate calculation');
      }
      if (totalCholesterol < 130 || totalCholesterol > 320) {
        warnings.add('Total cholesterol outside typical range (130-320 mg/dL)');
      }
      if (hdlCholesterol < 20 || hdlCholesterol > 100) {
        warnings.add('HDL cholesterol outside typical range (20-100 mg/dL)');
      }
      if (systolicBP < 90 || systolicBP > 200) {
        warnings.add('Systolic BP outside typical range (90-200 mmHg)');
      }
    });
  }

  void calculateRisk() {
    validateInputs();
    
    double risk = calculateASCVD(
      age: age,
      sex: sex,
      race: race,
      totalCholesterol: totalCholesterol,
      hdlCholesterol: hdlCholesterol,
      systolicBP: systolicBP,
      onHypertensionTreatment: onHypertensionTreatment,
      smoker: smoker,
      diabetes: diabetes,
    );
    setState(() => riskResult = risk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('ASCVD Risk Calculator', style: appbarTestStyle,),
        centerTitle: true,
        elevation: 0,
       backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 2,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(FontAwesomeIcons.heartPulse, size: 48, color: Colors.red[400]),
                      const SizedBox(height: 12),
                      Text(
                        '10-Year Heart Disease Risk',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your health information below',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Warnings - Show at the top
              if (warnings.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orange[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
                            const SizedBox(width: 8),
                            Text(
                              'Unrealistic Values Detected',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: warnings.map((warning) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.orange[800]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    warning,
                                    style: TextStyle(color: Colors.orange[900]),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Demographics Section
              _buildSectionHeader('Demographics', Icons.person),
              const SizedBox(height: 12),
              
              _buildInputCard(
                child: Column(
                  children: [
                    _buildSliderField(
                      label: 'Age',
                      value: age.toDouble(),
                      min: 20,
                      max: 79,
                      divisions: 59,
                      unit: 'years',
                      onChanged: (v) {
                        age = v.round();
                        validateInputs();
                      },
                    ),
                    const Divider(height: 32),
                    _buildDropdownField(
                      label: 'Sex',
                      value: sex,
                      icon: Icons.wc,
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(value: 'female', child: Text('Female')),
                      ],
                      onChanged: (v) => setState(() => sex = v!),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Race',
                      value: race,
                      icon: Icons.public,
                      items: const [
                        DropdownMenuItem(value: 'white', child: Text('White / Other')),
                        DropdownMenuItem(value: 'african_american', child: Text('African American')),
                      ],
                      onChanged: (v) => setState(() => race = v!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Lab Values Section
              _buildSectionHeader('Lab Values', Icons.science),
              const SizedBox(height: 12),
              
              _buildInputCard(
                child: Column(
                  children: [
                    _buildSliderField(
                      label: 'Total Cholesterol',
                      value: totalCholesterol,
                      min: 100,
                      max: 400,
                      divisions: 60,
                      unit: 'mg/dL',
                      onChanged: (v) {
                        totalCholesterol = v;
                        validateInputs();
                      },
                    ),
                    const Divider(height: 32),
                    _buildSliderField(
                      label: 'HDL Cholesterol',
                      value: hdlCholesterol,
                      min: 20,
                      max: 100,
                      divisions: 80,
                      unit: 'mg/dL',
                      onChanged: (v) {
                        hdlCholesterol = v;
                        validateInputs();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Blood Pressure Section
              _buildSectionHeader('Blood Pressure', Icons.monitor_heart),
              const SizedBox(height: 12),
              
              _buildInputCard(
                child: Column(
                  children: [
                    _buildSliderField(
                      label: 'Systolic BP',
                      value: systolicBP,
                      min: 90,
                      max: 200,
                      divisions: 110,
                      unit: 'mmHg',
                      onChanged: (v) {
                        systolicBP = v;
                        validateInputs();
                      },
                    ),
                    const Divider(height: 32),
                    _buildSwitchTile(
                      title: 'On Blood Pressure Treatment',
                      icon: Icons.medication,
                      value: onHypertensionTreatment,
                      onChanged: (v) => setState(() => onHypertensionTreatment = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Health Conditions Section
              _buildSectionHeader('Health Conditions', Icons.health_and_safety),
              const SizedBox(height: 12),
              
              _buildInputCard(
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: 'Current Smoker',
                      icon: Icons.smoking_rooms,
                      value: smoker,
                      onChanged: (v) => setState(() => smoker = v),
                    ),
                    const Divider(height: 24),
                    _buildSwitchTile(
                      title: 'Diabetes',
                      icon: Icons.water_drop,
                      value: diabetes,
                      onChanged: (v) => setState(() => diabetes = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Calculate Button
              ElevatedButton(
                onPressed: calculateRisk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBgColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate, size: 24),
                    SizedBox(width: 8),
                    Text('Calculate Risk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // Result Card
              if (riskResult != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _riskColor(riskResult!).withOpacity(0.1),
                          _riskColor(riskResult!).withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            _riskIcon(riskResult!),
                            size: 64,
                            color: _riskColor(riskResult!),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '10-Year ASCVD Risk',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${riskResult!.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _riskColor(riskResult!),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _riskColor(riskResult!),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _riskCategory(riskResult!),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _riskDescription(riskResult!),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "This result is an estimate based on the ACC/AHA 2013 pooled cohort equations. "
                        "It should not replace professional medical advice. Please consult your healthcare provider.",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: mainBgColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard({required Widget child}) {
    return Card(
      color: Colors.grey[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _buildSliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xffedfaf1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.round()} $unit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainBgColor,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: mainBgColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: mainBgColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              DropdownButton<String>(
                value: value,
                isExpanded: true,
                underline: const SizedBox(),
                items: items,
                onChanged: onChanged,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: value ? mainBgColor : Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          inactiveTrackColor: Colors.grey[300],
          inactiveThumbColor: Colors.grey[100],
          activeThumbColor: mainBgColor,
          //activeTrackColor: Colors.pink,
        ),
      ],
    );
  }

  String _riskCategory(double risk) {
    if (risk < 5) return 'Low Risk';
    if (risk < 7.5) return 'Borderline Risk';
    if (risk < 20) return 'Intermediate Risk';
    return 'High Risk';
  }

  Color _riskColor(double risk) {
    if (risk < 5) return Colors.green;
    if (risk < 7.5) return Colors.orange;
    if (risk < 20) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _riskIcon(double risk) {
    if (risk < 5) return Icons.check_circle;
    if (risk < 7.5) return Icons.warning_amber_rounded;
    if (risk < 20) return Icons.error_outline;
    return Icons.dangerous;
  }

  String _riskDescription(double risk) {
    if (risk < 5) {
      return 'Your risk is low. Continue maintaining a healthy lifestyle.';
    } else if (risk < 7.5) {
      return 'Your risk is borderline. Consider lifestyle modifications.';
    } else if (risk < 20) {
      return 'Your risk is intermediate. Discuss treatment options with your doctor.';
    }
    return 'Your risk is high. Please consult your healthcare provider soon.';
  }
}

/// =============================
/// ACC/AHA 2013 Pooled Cohort Equation
/// =============================
double calculateASCVD({
  required int age,
  required String sex,
  required String race,
  required double totalCholesterol,
  required double hdlCholesterol,
  required double systolicBP,
  required bool onHypertensionTreatment,
  required bool smoker,
  required bool diabetes,
}) {
  final coefficients = _getCoefficients(sex, race);
  final lnAge = log(age.toDouble());
  final lnTC = log(totalCholesterol);
  final lnHDL = log(hdlCholesterol);
  final lnSBP = log(systolicBP);

  final treated = onHypertensionTreatment ? lnSBP : 0;
  final untreated = onHypertensionTreatment ? 0 : lnSBP;

  final linearPredictor = (coefficients['ln_age']! * lnAge) +
      (coefficients['ln_tc']! * lnTC) +
      (coefficients['ln_hdl']! * lnHDL) +
      (coefficients['ln_age_tc']! * lnAge * lnTC) +
      (coefficients['ln_age_hdl']! * lnAge * lnHDL) +
      (coefficients['ln_sbp_treated']! * treated) +
      (coefficients['ln_sbp_untreated']! * untreated) +
      (coefficients['smoker']! * (smoker ? 1 : 0)) +
      (coefficients['ln_age_smoker']! * lnAge * (smoker ? 1 : 0)) +
      (coefficients['diabetes']! * (diabetes ? 1 : 0));

  final mean = coefficients['mean']!;
  final s0 = coefficients['s0']!;
  final risk = 1 - pow(s0, exp(linearPredictor - mean));

  return ((risk * 100).clamp(0, 100) as double);
}

Map<String, double> _getCoefficients(String sex, String race) {
  if (sex == 'male' && race == 'african_american') {
    return {
      'ln_age': 2.469,
      'ln_tc': 0.302,
      'ln_hdl': -0.307,
      'ln_age_tc': 0,
      'ln_age_hdl': 0,
      'ln_sbp_treated': 1.916,
      'ln_sbp_untreated': 1.809,
      'smoker': 0.549,
      'ln_age_smoker': 0,
      'diabetes': 0.645,
      'mean': 19.5425,
      's0': 0.8954,
    };
  } else if (sex == 'female' && race == 'african_american') {
    return {
      'ln_age': 17.114,
      'ln_tc': 0.940,
      'ln_hdl': -18.920,
      'ln_age_tc': 4.475,
      'ln_age_hdl': 29.291,
      'ln_sbp_treated': 27.820,
      'ln_sbp_untreated': 27.820,
      'smoker': 0.691,
      'ln_age_smoker': 0,
      'diabetes': 0.874,
      'mean': 86.61,
      's0': 0.9533,
    };
  } else if (sex == 'female') {
    return {
      'ln_age': -29.799,
      'ln_tc': 13.540,
      'ln_hdl': -13.578,
      'ln_age_tc': -3.114,
      'ln_age_hdl': 3.149,
      'ln_sbp_treated': 2.019,
      'ln_sbp_untreated': 1.957,
      'smoker': 7.574,
      'ln_age_smoker': -1.665,
      'diabetes': 0.661,
      'mean': -29.18,
      's0': 0.9665,
    };
  } else {
    return {
      'ln_age': 12.344,
      'ln_tc': 11.853,
      'ln_hdl': -7.990,
      'ln_age_tc': -2.664,
      'ln_age_hdl': 1.769,
      'ln_sbp_treated': 1.797,
      'ln_sbp_untreated': 1.764,
      'smoker': 7.837,
      'ln_age_smoker': -1.795,
      'diabetes': 0.658,
      'mean': 61.18,
      's0': 0.9144,
    };
  }
}