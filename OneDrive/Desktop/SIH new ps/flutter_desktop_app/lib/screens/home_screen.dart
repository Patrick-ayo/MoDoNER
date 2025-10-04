import 'package:flutter/material.dart';
import '../widgets/metric_card.dart';
import '../widgets/svg_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real data
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome to DPR Assessment System', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('Advanced AI-powered system for automated evaluation of DPRs.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Text('System Overview', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          // Equal-width metric cards across the full width
          Row(
            children: [
              Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: MetricCard(leading: const SvgIcon('assets/icons/dashboard.svg', size: 28), title: 'Total DPRs Processed', value: '1,247', borderColor: Theme.of(context).colorScheme.primary))),
              Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: MetricCard(leading: const SvgIcon('assets/icons/analysis.svg', size: 28), title: 'Avg Processing Time', value: '2.5 hrs', borderColor: Colors.teal))),
              Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: MetricCard(leading: const SvgIcon('assets/icons/reports.svg', size: 28), title: 'Accuracy Rate', value: '94.3%', borderColor: Colors.green))),
              Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: MetricCard(leading: const SvgIcon('assets/icons/home.svg', size: 28), title: 'Time Reduced', value: '78%', borderColor: Colors.orange))),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recent DPR Submissions', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          // Recent DPR Submissions - expandable box that will grow with content
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 120, maxHeight: 400),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent DPR Submissions', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3, // replace with dynamic count from DB
                    itemBuilder: (_, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/logo.png'),
                        onBackgroundImageError: (_, __) {},
                      ),
                      title: Text('DPR Project #${i+1}'),
                      subtitle: Text('State • Category • ₹100 Cr'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
