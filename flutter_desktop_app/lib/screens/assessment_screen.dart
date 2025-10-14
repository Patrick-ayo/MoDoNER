import 'package:flutter/material.dart';
import '../widgets/progress_bar.dart';
import '../widgets/risk_indicator.dart';
import '../widgets/metric_card.dart';

class AssessmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example static data
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assessment Dashboard', style: Theme.of(context).textTheme.displayMedium),
          SizedBox(height: 8),
          Text('Real-time monitoring of DPR progress', style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 24),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('NH-37 Highway Extension Project', style: Theme.of(context).textTheme.headlineSmall)),
                      RiskIndicator(level: 'Medium'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Road Construction • Assam • ₹450 Crores'),
                  SizedBox(height: 16),
                  const ProgressBar(percentage: 100, color: Colors.green),
                  const SizedBox(height: 8),
                  ProgressBar(percentage: 87, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  const ProgressBar(percentage: 73, color: Colors.orange),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          Text('Live System Metrics', style: Theme.of(context).textTheme.headlineLarge),
          Wrap(
            spacing: 8,
            children: [
              MetricCard(icon: Icons.hourglass_empty, title: 'Queue', value: '12', borderColor: Colors.orange),
              MetricCard(icon: Icons.check, title: 'Completed', value: '8', borderColor: Colors.green),
              MetricCard(icon: Icons.storage, title: 'Load', value: '67%', borderColor: Theme.of(context).primaryColor),
              MetricCard(icon: Icons.assessment, title: 'Accuracy', value: '94.3%', borderColor: Color(0xFF059669)),
            ],
          ),
        ],
      ),
    );
  }
}
