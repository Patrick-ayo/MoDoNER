import 'package:flutter/material.dart';
import '../widgets/svg_icon.dart';
import 'analysis_screen.dart';
import '../theme.dart';

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
          // Quick access cards (includes Analysis action)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalysisScreen())),
                  child: Card(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const SvgIcon('assets/icons/analysis.svg', size: 36),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Run Analysis', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text('Open analysis tools and reports', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Expanded Analysis preview (charts + POE list)
          Text('Analysis Overview', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Analysis', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  // Mock charts row
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalysisScreen())),
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.primary.withOpacity(0.05)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.show_chart, size: 36, color: AppTheme.accentCyan),
                                  const SizedBox(height: 8),
                                  Text('Accuracy Trend', style: Theme.of(context).textTheme.bodyLarge),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalysisScreen())),
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.primary.withOpacity(0.05)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.pie_chart, size: 36, color: Colors.green),
                                  const SizedBox(height: 8),
                                  Text('Category Distribution', style: Theme.of(context).textTheme.bodyLarge),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Points of Evaluation (POE)', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  // POE list
                  Column(
                    children: List.generate(3, (i) => ListTile(
                      leading: CircleAvatar(child: Text('${i+1}')),
                      title: Text('POE ${i+1}: Completeness'),
                      subtitle: Text('Score: ${[95,78,88][i]}%'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalysisScreen())),
                    )),
                  ),
                ],
              ),
            ),
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
