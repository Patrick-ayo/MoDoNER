import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class AnalysisScreen extends StatelessWidget {
  final AnalysisResult? result;

  AnalysisScreen({super.key, this.result});

  Color _scoreColor(double score) {
    if (score >= 85) return Colors.green;
    if (score >= 65) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Analysis')),
        body: const Center(child: Text('No analysis selected')),
      );
    }
    final res = result!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(res.title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 12),

          // Compliance score prominent
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Compliance Score', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('${res.complianceScore.toStringAsFixed(1)}%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _scoreColor(res.complianceScore))),
                    const SizedBox(height: 8),
                    Text('Risk Prediction: ${res.riskScore.toStringAsFixed(1)}%', style: TextStyle(color: res.riskScore > 60 ? Colors.red : Colors.green)),
                  ]),
                ),
                // Visual indicator
                SizedBox(width: 140, height: 140, child: Center(child: Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 120, height: 120, child: CircularProgressIndicator(value: res.complianceScore / 100, strokeWidth: 12, color: _scoreColor(res.complianceScore), backgroundColor: Colors.grey.shade200)),
                  Text('${res.complianceScore.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                ]))),
              ]),
            ),
          ),

          const SizedBox(height: 12),

          // Mismatched budgets / cost overrun emphasized
          Card(
            color: res.mismatchedBudgets.isNotEmpty ? Colors.red.shade50 : null,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Budget Analysis', style: Theme.of(context).textTheme.headlineSmall),
                  Text('Overrun: ${res.costOverrunPercent.toStringAsFixed(1)}%', style: TextStyle(color: res.costOverrunPercent > 5 ? Colors.red : Colors.green)),
                ]),
                const SizedBox(height: 8),
                if (res.mismatchedBudgets.isEmpty) Text('No significant budget mismatches detected.'),
                for (final m in res.mismatchedBudgets) Padding(padding: const EdgeInsets.symmetric(vertical:6.0), child: Text('• $m', style: const TextStyle(fontWeight: FontWeight.w600))),
              ]),
            ),
          ),

          const SizedBox(height: 12),

          // Timeline and delays
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Timeline Analysis', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Unrealistic timelines: ${res.unrealisticTimelines ? 'Yes' : 'No'}', style: TextStyle(color: res.unrealisticTimelines ? Colors.red : Colors.green)),
                const SizedBox(height: 8),
                Text('Predicted delay (days): ${res.delayDays}'),
              ]),
            ),
          ),

          const SizedBox(height: 12),

          // Notes / comments
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Notes & Comments', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                if (res.notes.isEmpty) const Text('No notes'),
                for (final n in res.notes) Padding(padding: const EdgeInsets.symmetric(vertical:4.0), child: Text('• $n')),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
