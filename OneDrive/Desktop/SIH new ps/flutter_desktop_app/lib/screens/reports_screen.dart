import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/project_log_item.dart';

// Enums for state management
enum TaskStatus { all, todo, ongoing, completed }
enum RiskLevel { all, high, medium, low }
enum ReportType { individual, monthly, comparative, compliance }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text('Generate reports or browse project logs', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Generate Report'),
            Tab(text: 'Project Logs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GenerateReportView(),
          ProjectLogsView(),
        ],
      ),
    );
  }
}

// --- WIDGET FOR TAB 1: GENERATE REPORT ---
class GenerateReportView extends StatefulWidget {
  const GenerateReportView({super.key});
  @override
  State<GenerateReportView> createState() => _GenerateReportViewState();
}

class _GenerateReportViewState extends State<GenerateReportView> {
  // All the state and logic for this tab is self-contained
  String searchQuery = '';
  Timer? _searchDebounce;
  DateTime? selectedDate;
  TaskStatus selectedStatus = TaskStatus.all;
  String selectedSector = 'All';
  RiskLevel selectedRiskLevel = RiskLevel.all;
  ReportType selectedReportType = ReportType.individual;
  final List<TaskStatus> statusOptions = const [TaskStatus.all, TaskStatus.todo, TaskStatus.ongoing, TaskStatus.completed];
  final Map<String, List<String>> sectorCategories = {
    'Physical Infrastructure': ['Roads & Bridges', 'Water Supply & Sanitation', 'Power & Electrification', 'Irrigation & Flood Control', 'Urban Infrastructure'],
    'Social Infrastructure': ['Health Facilities', 'Education Infrastructure', 'Sports Infrastructure'],
  };
  late final List<String> sectorOptions;
  final List<RiskLevel> riskLevelOptions = const [RiskLevel.all, RiskLevel.high, RiskLevel.medium, RiskLevel.low];

  @override
  void initState() {
    super.initState();
    sectorOptions = ['All', for (final entry in sectorCategories.entries) ...[entry.key, ...entry.value]];
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    final d = date.toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String statusLabel(TaskStatus status) => status.toString().split('.').last.capitalize();
  String riskLabel(RiskLevel risk) => risk.toString().split('.').last.capitalize();

  void _showFilterDialog() { /* Paste your dialog code here */ }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search reports...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
                      if (!mounted) return;
                      setState(() => searchQuery = value);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _showFilterDialog,
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ReportType.values.map((type) {
              return ChoiceChip(
                label: Text(type.toString().split('.').last.capitalize()),
                selected: selectedReportType == type,
                onSelected: (selected) => setState(() => selectedReportType = type),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.accentCyan,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Report'),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET FOR TAB 2: PROJECT LOGS ---
class ProjectLogsView extends StatefulWidget {
  const ProjectLogsView({super.key});
  @override
  State<ProjectLogsView> createState() => _ProjectLogsViewState();
}

class _ProjectLogsViewState extends State<ProjectLogsView> {
  final List<Map<String, dynamic>> projectLogs = [
    {'name': 'Project Alpha', 'id': 'PR-102', 'riskLevel': 'Medium Risk', 'progress': 75, 'submissionDate': 'Apr 23, 2024'},
    {'name': 'Project Beta', 'id': 'PR-098', 'riskLevel': 'Medium Risk', 'progress': 90, 'submissionDate': 'Apr 19, 2024'},
    {'name': 'Project Gamma', 'id': 'PR-076', 'riskLevel': 'Low Risk', 'progress': 100, 'submissionDate': 'Apr 18, 2024'},
    {'name': 'Project Delta', 'id': 'PR-054', 'riskLevel': 'High Risk', 'progress': 40, 'submissionDate': 'Apr 12, 2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...projectLogs.map((data) => ProjectLogItem(
              name: data['name'],
              id: data['id'],
              riskLevel: data['riskLevel'],
              progress: data['progress'],
              submissionDate: data['submissionDate'],
            )),
        const SizedBox(height: 80), // Padding for the FAB
      ],
    );
  }
}

// Helper extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}