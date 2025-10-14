import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/charts/approval_rate_chart.dart';
import '../widgets/charts/common_issues_chart.dart';
import '../widgets/charts/average_risk_chart.dart';
import '../widgets/charts/compliance_bar_chart.dart'; // Import the final chart

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 4),
          Text('In-depth project insights', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Approval Rate'),
              Tab(text: 'Avg Issues'),
              Tab(text: 'Avg Risk'),
              Tab(text: 'Compliance vs. Outcome'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ApprovalRateChart(),
                CommonIssuesChart(),
                AverageRiskChart(),
                // The final chart is now in the fourth tab
                ComplianceBarChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}