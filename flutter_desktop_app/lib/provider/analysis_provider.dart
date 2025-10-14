import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class AnalysisProvider extends ChangeNotifier {
  final List<AnalysisResult> _results = [];

  List<AnalysisResult> get results => List.unmodifiable(_results);

  Future<AnalysisResult> analyzeDocument({required String title, required String docType, String? comment}) async {
    // Mock analysis logic: produce deterministic but varied metrics
    await Future.delayed(const Duration(seconds: 1));
    final base = title.hashCode.abs() % 100;
    final compliance = (70 + (base % 25)).clamp(30, 100).toDouble();
    final risk = (100 - compliance) + (base % 10).toDouble();
    final costOverrun = ((base % 30) - 5).toDouble();
    final unrealistic = base % 7 == 0;
    final delays = (base % 60) - 10;
    final mismatches = <String>[];
    if (costOverrun > 5) mismatches.add('Estimated budget differs by ${costOverrun.toStringAsFixed(1)}% from historical averages');
    if (unrealistic) mismatches.add('Timeline appears optimistic compared to similar projects');

    final result = AnalysisResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$docType - $title',
      complianceScore: compliance,
      riskScore: risk.clamp(0, 100),
      costOverrunPercent: costOverrun,
      unrealisticTimelines: unrealistic,
      delayDays: delays > 0 ? delays : 0,
      notes: comment != null ? [comment] : [],
      mismatchedBudgets: mismatches,
    );

    _results.insert(0, result);
    notifyListeners();
    return result;
  }
}
