class AnalysisResult {
  final String id;
  final String title;
  final double complianceScore; // 0-100
  final double riskScore; // 0-100
  final double costOverrunPercent;
  final bool unrealisticTimelines;
  final int delayDays;
  final List<String> notes;
  final List<String> mismatchedBudgets; // descriptions

  AnalysisResult({
    required this.id,
    required this.title,
    required this.complianceScore,
    required this.riskScore,
    required this.costOverrunPercent,
    required this.unrealisticTimelines,
    required this.delayDays,
    required this.notes,
    required this.mismatchedBudgets,
  });
}
