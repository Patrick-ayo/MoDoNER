import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/action_button.dart';
import '../widgets/evaluations_chart.dart';
import '../widgets/flagged_issues_card.dart';
import '../widgets/risk_predictions_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/submission_list_item.dart';

enum HomeTab { analytics, flaggedIssues, riskPrediction }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _selectedTab = HomeTab.analytics;

  // State variable to track if the submissions list is expanded
  bool _isSubmissionsExpanded = false;

  // Mock data moved to be a class member with more items
  final List<Map<String, dynamic>> _recentSubmissions = [
    {'name': 'NH-37 Highway Extension - Guwahati to Dimapur', 'riskScore': 72},
  {'name': 'Tawang District Hospital Modernization', 'riskScore': 45},
  {'name': 'Kaziranga Eco-Tourism Infrastructure Development', 'riskScore': 38},
  {'name': 'Shillong Smart City Water Supply Network', 'riskScore': 65},
  {'name': 'Imphal Valley Integrated Irrigation Project', 'riskScore': 81},
  {'name': 'Aizawl Digital Connectivity & Data Center', 'riskScore': 28},
  {'name': 'Kohima Heritage Site Preservation & Tourism', 'riskScore': 52},
  {'name': 'Agartala Solar Power Grid Expansion', 'riskScore': 89},
  {'name': 'Itanagar Border Road & Helipad Construction', 'riskScore': 94},
  {'name': 'Tura Watershed Management & Afforestation', 'riskScore': 41},
  {'name': 'Dibrugarh Skill Development & Training Center', 'riskScore': 33},
  {'name': 'Gangtok-Nathula Road Infrastructure Upgrade', 'riskScore': 76},
  ];

  final int _submissionLimit = 5;

  @override
  Widget build(BuildContext context) {
    // Calculate how many items to show based on the expansion state
    final int itemCountToShow = _isSubmissionsExpanded
        ? _recentSubmissions.length
        : min(_recentSubmissions.length, _submissionLimit);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 700;
            if (isNarrow) {
              return SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    const SizedBox(width: 8),
                    SizedBox(width: 220, child: StatCard(value: '120', label: 'Total DPRs Submitted')),
                    const SizedBox(width: 12),
                    SizedBox(width: 220, child: StatCard(value: '95', label: 'Completed Evaluations')),
                    const SizedBox(width: 12),
                    SizedBox(width: 220, child: StatCard(value: '80%', label: 'Average Complete')),
                    const SizedBox(width: 12),
                    SizedBox(width: 220, child: StatCard(value: '10', label: 'Active Projects')),
                    const SizedBox(width: 8),
                  ]),
                ),
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: StatCard(value: '120', label: 'Total DPRs Submitted')),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(value: '95', label: 'Completed Evaluations')),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(value: '80%', label: 'Average Complete')),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(value: '10', label: 'Active Projects')),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: ActionButton(text: 'Analytics', isPrimary: _selectedTab == HomeTab.analytics, onPressed: () => setState(() => _selectedTab = HomeTab.analytics))),
              const SizedBox(width: 12),
              Expanded(child: ActionButton(text: 'Flagged Issues', isPrimary: _selectedTab == HomeTab.flaggedIssues, onPressed: () => setState(() => _selectedTab = HomeTab.flaggedIssues))),
              const SizedBox(width: 12),
              Expanded(child: ActionButton(text: 'Risk Prediction', isPrimary: _selectedTab == HomeTab.riskPrediction, onPressed: () => setState(() => _selectedTab = HomeTab.riskPrediction))),
            ],
          ),
          const SizedBox(height: 24),
          if (_selectedTab == HomeTab.analytics)
            const EvaluationsChart()
          else if (_selectedTab == HomeTab.flaggedIssues)
            const FlaggedIssuesCard()
          else if (_selectedTab == HomeTab.riskPrediction)
            const RiskPredictionsCard(),
          const SizedBox(height: 24),

          Text('Recent DPR Submissions', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          
          ListView.builder(
            itemCount: itemCountToShow, // Use the dynamically calculated item count
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final submission = _recentSubmissions[index];
              return SubmissionListItem(
                index: index,
                name: submission['name'],
                riskScore: submission['riskScore'],
              );
            },
          ),
          
          // Conditionally show the "View More" / "View Less" button
          if (_recentSubmissions.length > _submissionLimit)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton.icon(
                  icon: Icon(_isSubmissionsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  label: Text(_isSubmissionsExpanded ? 'View Less' : 'View More'),
                  onPressed: () {
                    setState(() {
                      _isSubmissionsExpanded = !_isSubmissionsExpanded;
                    });
                  },
                ),
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}