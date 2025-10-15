// lib/screens/project_details_screen.dart
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/risk_indicator.dart';
import '../widgets/notes_button.dart';
import '../widgets/chatbot_popup.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> projectData;

  const ProjectDetailsScreen({super.key, required this.projectData});

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high risk':
        return AppTheme.error;
      case 'medium risk':
        return AppTheme.warning;
      case 'low risk':
        return AppTheme.success;
      case 'pending':
        return AppTheme.warning;
      default:
        return Colors.grey;
    }
  }

  void _showChatbotPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChatbotPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract data from projectData
    final String projectName = projectData['name'] ?? 'Unknown Project';
    final String projectId = projectData['id'] ?? 'N/A';
    final String riskLevel = projectData['riskLevel'] ?? 'Pending';
    final String projectStatus = 'Pending'; // Example status, could be from projectData
    final String dprDocumentName = 'NATIONAL HIGHWAY CORRIDOR...';
  // chatbot message/date removed (not used in current UI)

    // Dummy notes data
    final List<Map<String, dynamic>> projectNotes = [
      {'text': 'Needs clarification on timeline.', 'user': 'Admin', 'date': 'Apr 26, 2024'},
      {'text': 'Financial mismatch identified.', 'user': 'User1', 'date': 'Apr 27, 2024'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$projectName ($projectId)'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: RiskIndicator(level: riskLevel),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Title and Status Tag
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 420;
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      projectName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getRiskColor(projectStatus).withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _getRiskColor(projectStatus), width: 1),
                      ),
                      child: Text(
                        projectStatus,
                        style: TextStyle(
                          color: _getRiskColor(projectStatus),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Project Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(child: NotesButton(notes: projectNotes)),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Analysis: In Progress', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 20),
                    LayoutBuilder(builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 360;
                      if (isNarrow) {
                        return Column(
                          children: [
                            _buildGauge('Cost overrun', 0.68, AppTheme.error),
                            const SizedBox(height: 8),
                            _buildGauge('Timeline', 0.55, AppTheme.warning),
                            const SizedBox(height: 8),
                            _buildGauge('Environmental', 0.40, AppTheme.success),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildGauge('Cost overrun', 0.68, AppTheme.error),
                          _buildGauge('Timeline', 0.55, AppTheme.warning),
                          _buildGauge('Environmental', 0.40, AppTheme.success),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // DPR Document & Flagged Issues Section
            Text(
              'DPR Document & Flagged Issues',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description, color: AppTheme.accentCyan),
                      title: Text(dprDocumentName, style: Theme.of(context).textTheme.bodyLarge),
                      trailing: IconButton(
                        icon: const Icon(Icons.download, color: Colors.grey),
                        onPressed: () {
                          // TODO: Implement document download
                        },
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Inconsistency Findings', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              _buildFindingItem(context, 'Financial Mismatch', false),
                              _buildFindingItem(context, 'Environmental Risk', false),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Compliance Findings', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              _buildFindingItem(context, 'Safety Criteria', true),
                              _buildFindingItem(context, 'Material Specifications', true, isWarning: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Project Timeline & Notes Section
            Text(
              'Project Timeline',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimelineItem(context, 'DPR Uploaded', isFirst: true),
                    _buildTimelineItem(context, 'AI Analysis Started'),
                    _buildTimelineItem(context, 'Manual Review Started', isLast: true),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Chatbot Section
            // Text(
            //   'Chatbot',
            //   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 12),
            // Card(
            //   color: Theme.of(context).colorScheme.surface,
            //   elevation: 1,
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(chatbotMessage, style: Theme.of(context).textTheme.bodyLarge),
            //         const SizedBox(height: 4),
            //         Text(
            //           chatbotUserDate,
            //           style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChatbotPopup(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Chat with AI Assistant',
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildGauge(String label, double value, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  backgroundColor: color.withAlpha((0.2 * 255).round()),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildFindingItem(BuildContext context, String text, bool isCompliance, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isCompliance
                ? (isWarning ? Icons.warning : Icons.check_circle)
                : Icons.cancel,
            color: isCompliance
                ? (isWarning ? AppTheme.warning : AppTheme.success)
                : AppTheme.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String text, {bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(context).dividerColor.withAlpha((0.5 * 255).round()),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}