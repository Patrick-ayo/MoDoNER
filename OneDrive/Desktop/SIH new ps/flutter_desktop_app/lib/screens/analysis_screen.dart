import 'package:flutter/material.dart';
import '../widgets/progress_bar.dart';

class AnalysisScreen extends StatelessWidget {
  final sections = [
    {'name': 'Executive Summary', 'compl': 95, 'quality': 'Excellent', 'issues': 0},
    {'name': 'Cost Estimates', 'compl': 76, 'quality': 'Fair', 'issues': 4},
    // ... more
  ];

  Color _qualityColor(BuildContext context, String q) {
    switch (q.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Theme.of(context).colorScheme.primary;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, i) {
          final s = sections[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s['name'] as String,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _qualityColor(context, s['quality'] as String),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          s['quality'] as String,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Issues: ${s['issues']}'),
                  const SizedBox(height: 8),
                  ProgressBar(
                    percentage: (s['compl'] as int).toDouble(),
                    color: _qualityColor(context, s['quality'] as String),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
