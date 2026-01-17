import 'package:flutter/material.dart';
import '../models/blood_pressure.dart';

/// Health status categories
enum HealthStatus { low, normal, high, abnormal }

/// Result with status and color coding
class HealthResult {
  final HealthStatus status;
  final String statusText;
  final Color color;
  final String recommendation;

  HealthResult({
    required this.status,
    required this.statusText,
    required this.color,
    required this.recommendation,
  });

  static HealthResult low(String recommendation) => HealthResult(
    status: HealthStatus.low,
    statusText: 'Low',
    color: Colors.blue,
    recommendation: recommendation,
  );

  static HealthResult normal(String recommendation) => HealthResult(
    status: HealthStatus.normal,
    statusText: 'Normal',
    color: Colors.green,
    recommendation: recommendation,
  );

  static HealthResult high(String recommendation) => HealthResult(
    status: HealthStatus.high,
    statusText: 'High',
    color: Colors.orange,
    recommendation: recommendation,
  );

  static HealthResult abnormal(String recommendation) => HealthResult(
    status: HealthStatus.abnormal,
    statusText: 'Abnormal',
    color: Colors.red,
    recommendation: recommendation,
  );
}

/// Health Analysis Utility class
class HealthAnalysis {
  // ============= Blood Pressure Analysis =============
  static HealthResult analyzeSystolic(int systolic) {
    if (systolic < 90) {
      return HealthResult.low(
        'Blood pressure is low. Consider consulting a doctor if you feel dizzy or fatigued.',
      );
    } else if (systolic <= 120) {
      return HealthResult.normal(
        'Systolic blood pressure is optimal. Keep maintaining a healthy lifestyle.',
      );
    } else if (systolic <= 139) {
      return HealthResult.high(
        'Prehypertension. Consider lifestyle changes like reducing salt and exercising.',
      );
    } else {
      return HealthResult.abnormal(
        'Hypertension detected. Please consult a healthcare provider.',
      );
    }
  }

  static HealthResult analyzeDiastolic(int diastolic) {
    if (diastolic < 60) {
      return HealthResult.low(
        'Diastolic is low. Monitor and consult if symptoms persist.',
      );
    } else if (diastolic <= 80) {
      return HealthResult.normal('Diastolic blood pressure is optimal.');
    } else if (diastolic <= 89) {
      return HealthResult.high(
        'Prehypertension. Lifestyle modifications recommended.',
      );
    } else {
      return HealthResult.abnormal(
        'High diastolic pressure. Medical attention recommended.',
      );
    }
  }

  static HealthResult analyzeBloodPressure(BloodPressure bp) {
    final systolicResult = analyzeSystolic(bp.systolic);
    final diastolicResult = analyzeDiastolic(bp.diastolic);

    // Return the worse of the two
    if (systolicResult.status == HealthStatus.abnormal ||
        diastolicResult.status == HealthStatus.abnormal) {
      return HealthResult.abnormal(
        'Blood pressure is ${bp.bpLevel}. Please consult a doctor.',
      );
    } else if (systolicResult.status == HealthStatus.high ||
        diastolicResult.status == HealthStatus.high) {
      return HealthResult.high(
        'Blood pressure is elevated at ${bp.bpLevel}. Monitor and consider lifestyle changes.',
      );
    } else if (systolicResult.status == HealthStatus.low ||
        diastolicResult.status == HealthStatus.low) {
      return HealthResult.low(
        'Blood pressure is low at ${bp.bpLevel}. Stay hydrated and monitor symptoms.',
      );
    } else {
      return HealthResult.normal(
        'Blood pressure ${bp.bpLevel} is within normal range. Keep it up!',
      );
    }
  }

  // ============= Fasting Blood Sugar Analysis =============
  static HealthResult analyzeFBS(double fbsLevel) {
    if (fbsLevel < 70) {
      return HealthResult.low(
        'Blood sugar is low (hypoglycemia). Eat something and monitor closely.',
      );
    } else if (fbsLevel <= 100) {
      return HealthResult.normal(
        'Fasting blood sugar is normal. Maintain healthy eating habits.',
      );
    } else if (fbsLevel <= 125) {
      return HealthResult.high(
        'Prediabetic range. Consider dietary changes and exercise.',
      );
    } else {
      return HealthResult.abnormal(
        'Diabetic range. Please consult a healthcare provider for proper management.',
      );
    }
  }

  // ============= Full Blood Count Analysis =============
  static HealthResult analyzeHaemoglobin(double value, String gender) {
    // Normal ranges differ by gender
    final isLow = gender.toLowerCase() == 'male' ? value < 13.5 : value < 12.0;
    final isHigh = gender.toLowerCase() == 'male' ? value > 17.5 : value > 15.5;

    if (isLow) {
      return HealthResult.low(
        'Low hemoglobin may indicate anemia. Consider iron-rich foods and consult doctor.',
      );
    } else if (isHigh) {
      return HealthResult.high(
        'High hemoglobin. Stay hydrated and consult if persistent.',
      );
    } else {
      return HealthResult.normal('Hemoglobin level is within normal range.');
    }
  }

  static HealthResult analyzeWBC(double count) {
    // Normal: 4,000-11,000 cells/mcL
    if (count < 4000) {
      return HealthResult.low(
        'Low WBC count. May indicate weakened immunity. Consult a doctor.',
      );
    } else if (count <= 11000) {
      return HealthResult.normal(
        'White blood cell count is normal. Immune system is healthy.',
      );
    } else {
      return HealthResult.high(
        'High WBC count may indicate infection or inflammation. Monitor and consult.',
      );
    }
  }

  static HealthResult analyzePlatelets(double count) {
    // Normal: 150,000-400,000 cells/mcL
    if (count < 150000) {
      return HealthResult.low(
        'Low platelet count. May cause bleeding issues. Consult a doctor.',
      );
    } else if (count <= 400000) {
      return HealthResult.normal('Platelet count is within normal range.');
    } else {
      return HealthResult.high(
        'High platelet count. Monitor and consult a healthcare provider.',
      );
    }
  }

  // ============= Lipid Profile Analysis =============
  static HealthResult analyzeTotalCholesterol(double value) {
    if (value < 200) {
      return HealthResult.normal(
        'Total cholesterol is desirable. Keep up healthy habits.',
      );
    } else if (value <= 239) {
      return HealthResult.high(
        'Borderline high cholesterol. Consider dietary changes.',
      );
    } else {
      return HealthResult.abnormal(
        'High cholesterol. Medical attention and lifestyle changes recommended.',
      );
    }
  }

  static HealthResult analyzeHDL(double value, String gender) {
    final minGood = gender.toLowerCase() == 'male' ? 40.0 : 50.0;
    if (value < minGood) {
      return HealthResult.low(
        'Low HDL (good cholesterol). Exercise and healthy fats can help increase it.',
      );
    } else if (value >= 60) {
      return HealthResult.normal(
        'Excellent HDL level. Provides protection against heart disease.',
      );
    } else {
      return HealthResult.normal(
        'HDL level is acceptable. Consider increasing through exercise.',
      );
    }
  }

  static HealthResult analyzeLDL(double value) {
    if (value < 100) {
      return HealthResult.normal('Optimal LDL level. Great for heart health.');
    } else if (value <= 129) {
      return HealthResult.normal(
        'Near optimal LDL. Maintain current lifestyle.',
      );
    } else if (value <= 159) {
      return HealthResult.high(
        'Borderline high LDL. Consider reducing saturated fat intake.',
      );
    } else if (value <= 189) {
      return HealthResult.high(
        'High LDL. Lifestyle changes and possibly medication needed.',
      );
    } else {
      return HealthResult.abnormal(
        'Very high LDL. Medical intervention recommended.',
      );
    }
  }

  static HealthResult analyzeTriglycerides(double value) {
    if (value < 150) {
      return HealthResult.normal('Triglyceride level is normal.');
    } else if (value <= 199) {
      return HealthResult.high(
        'Borderline high triglycerides. Limit sugar and refined carbs.',
      );
    } else if (value <= 499) {
      return HealthResult.high(
        'High triglycerides. Dietary changes and exercise recommended.',
      );
    } else {
      return HealthResult.abnormal(
        'Very high triglycerides. Medical attention needed.',
      );
    }
  }

  // ============= Liver Profile Analysis =============
  static HealthResult analyzeSGPT(double value) {
    // Normal: 7-56 U/L
    if (value < 7) {
      return HealthResult.low('SGPT is low, which is usually not a concern.');
    } else if (value <= 56) {
      return HealthResult.normal(
        'SGPT (ALT) is within normal range. Liver function appears healthy.',
      );
    } else if (value <= 100) {
      return HealthResult.high(
        'Mildly elevated SGPT. Monitor and avoid alcohol.',
      );
    } else {
      return HealthResult.abnormal(
        'Significantly elevated SGPT. Consult a doctor immediately.',
      );
    }
  }

  static HealthResult analyzeSGOT(double value) {
    // Normal: 10-40 U/L
    if (value < 10) {
      return HealthResult.low('SGOT is low, usually not concerning.');
    } else if (value <= 40) {
      return HealthResult.normal('SGOT (AST) is within normal range.');
    } else if (value <= 80) {
      return HealthResult.high('Elevated SGOT. Monitor liver health.');
    } else {
      return HealthResult.abnormal('High SGOT. Medical attention needed.');
    }
  }
}
