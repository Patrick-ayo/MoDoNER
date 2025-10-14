import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
// Enums to avoid hard-coded string usage and reduce typo risks
enum TaskStatus { all, todo, ongoing, completed }
enum RiskLevel { all, high, medium, low }
enum ReportType { individual, monthly, comparative, compliance }
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}
class _ReportsScreenState extends State<ReportsScreen> {
  String searchQuery = '';
  Timer? _searchDebounce;
  DateTime? selectedDate;
  TaskStatus selectedStatus = TaskStatus.all;
  String selectedSector = 'All';
  RiskLevel selectedRiskLevel = RiskLevel.all;
  ReportType selectedReportType = ReportType.individual;
  final List<TaskStatus> statusOptions = const [
    TaskStatus.all,
    TaskStatus.todo,
    TaskStatus.ongoing,
    TaskStatus.completed,
  ];
  // Hierarchical sector options with categories and sub-filters
  final Map<String, List<String>> sectorCategories = {
    'Physical Infrastructure': [
      'Roads & Bridges',
      'Water Supply & Sanitation',
      'Power & Electrification',
      'Irrigation & Flood Control',
      'Urban Infrastructure',
    ],
    'Social Infrastructure': [
      'Health Facilities',
      'Education Infrastructure',
      'Sports Infrastructure',
    ],
    'Livelihood & Economic Development': [
      'Agriculture & Horticulture',
      'Animal Husbandry & Fisheries',
      'Handloom, Handicrafts & MSMEs',
      'Skill Development & Entrepreneurship',
    ],
    'Environment & Sustainability': [
      'Watershed Management',
      'Afforestation & Biodiversity',
      'Eco-Tourism & Sustainable Tourism',
    ],
    'Technology & Innovation': [
      'IT Infrastructure & E-Governance',
      'Digital Connectivity & Data Centers',
      'AI/IoT Pilots',
    ],
    'Strategic & Border Area Development': [
      'Border Roads & Helipads',
      'Disaster Resilience Projects',
      'Security-Linked Infrastructure',
    ],
    'PM-DevINE & NEC': [
      'Youth & Women Empowerment',
      'Institutional Capacity Building',
      'Heritage & Cultural Preservation',
      'Green Energy & Climate Resilience',
    ],
  };
  // Cached sector options (computed once for performance)
  late final List<String> sectorOptions;
  final List<RiskLevel> riskLevelOptions = const [
    RiskLevel.all,
    RiskLevel.high,
    RiskLevel.medium,
    RiskLevel.low,
  ];
  @override
  void initState() {
    super.initState();
    // Pre-compute sector options
    sectorOptions = [
      'All',
      for (final entry in sectorCategories.entries) ...[
        entry.key,
        ...entry.value,
      ]
    ];
  }
  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
  // Helper: format date safely and consistently (without external deps)
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    final d = date.toLocal();
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
  // Map enums to labels
  String statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To-do';
      case TaskStatus.ongoing:
        return 'Ongoing';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.all:
      default:
        return 'All';
    }
  }
  String riskLabel(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.high:
        return 'High';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.all:
      default:
        return 'All';
    }
  }


  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Reports'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Filter
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(_formatDate(selectedDate)),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                // Status Filter
                DropdownButtonFormField<TaskStatus>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: statusOptions.map((TaskStatus value) {
                    return DropdownMenuItem<TaskStatus>(
                      value: value,
                      child: Text(statusLabel(value)),
                    );
                  }).toList(),
                  onChanged: (TaskStatus? newValue) {
                    if (newValue == null) return;
                    setState(() {
                      selectedStatus = newValue;
                    });
                  },
                  icon: const SizedBox(),
                ),
                const SizedBox(height: 8),
                // Sector Filter with categories
                DropdownButtonFormField<String>(
                  initialValue: selectedSector,
                  decoration: const InputDecoration(
                    labelText: 'Sector',
                  ),
                  items: sectorOptions.map((String value) {
                    // Check if this is a category header
                    bool isCategory = sectorCategories.containsKey(value);
                    return DropdownMenuItem<String>(
                      value: value,
                      enabled: !isCategory, // Disable category headers
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: isCategory ? 0 : 16.0, // Indent sub-filters
                        ),
                        child: Text(
                          value,
                          style: TextStyle(
                            fontWeight: isCategory ? FontWeight.bold : FontWeight.normal,
                            color: isCategory ? Colors.grey[600] : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() {
                      selectedSector = newValue;
                    });
                  },
                  icon: const SizedBox(),
                ),
                const SizedBox(height: 8),
                // Risk Level Filter
                DropdownButtonFormField<RiskLevel>(
                  initialValue: selectedRiskLevel,
                  decoration: const InputDecoration(
                    labelText: 'Risk Level',
                  ),
                  items: riskLevelOptions.map((RiskLevel value) {
                    return DropdownMenuItem<RiskLevel>(
                      value: value,
                      child: Text(riskLabel(value)),
                    );
                  }).toList(),
                  onChanged: (RiskLevel? newValue) {
                    if (newValue == null) return;
                    setState(() {
                      selectedRiskLevel = newValue;
                    });
                  },
                  icon: const SizedBox(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDate = null;
                  selectedStatus = TaskStatus.all;
                  selectedSector = 'All';
                  selectedRiskLevel = RiskLevel.all;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply filters logic here if needed
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reports & Analytics', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 4),
              Text('Generate and export evaluation reports', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 24),
          // Active Filters Display
          if (selectedDate != null ||
              selectedStatus != TaskStatus.all ||
              selectedSector != 'All' ||
              selectedRiskLevel != RiskLevel.all)
            Card(
              color: AppTheme.accentCyan.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Active Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (selectedDate != null)
                          Chip(
                            label: Text(_formatDate(selectedDate)),
                          ),
                        if (selectedStatus != TaskStatus.all)
                          Chip(
                            label: Text(statusLabel(selectedStatus)),
                          ),
                        if (selectedSector != 'All')
                          Chip(
                            label: Text(selectedSector),
                          ),
                        if (selectedRiskLevel != RiskLevel.all)
                          Chip(
                            label: Text(riskLabel(selectedRiskLevel)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (selectedDate != null ||
              selectedStatus != TaskStatus.all ||
              selectedSector != 'All' ||
              selectedRiskLevel != RiskLevel.all)
            const SizedBox(height: 16),
          // Search and Filter on same line
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search reports...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 24,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
                      if (!mounted) return;
                      setState(() {
                        searchQuery = value;
                      });
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Add your search logic here
                },
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Open filters',
                child: OutlinedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(
                    Icons.filter_list,
                    size: 22,
                    color: Colors.black87,
                  ),
                  label: const Text('Filter'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Report Types', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('👤 Individual Report'),
                selected: selectedReportType == ReportType.individual,
                onSelected: (selected) => setState(() => selectedReportType = ReportType.individual),
              ),
              ChoiceChip(
                label: const Text('📅 Monthly Summary'),
                selected: selectedReportType == ReportType.monthly,
                onSelected: (selected) => setState(() => selectedReportType = ReportType.monthly),
              ),
              ChoiceChip(
                label: const Text('⚖️ Comparative Analysis'),
                selected: selectedReportType == ReportType.comparative,
                onSelected: (selected) => setState(() => selectedReportType = ReportType.comparative),
              ),
              ChoiceChip(
                label: const Text('✅ Compliance Report'),
                selected: selectedReportType == ReportType.compliance,
                onSelected: (selected) => setState(() => selectedReportType = ReportType.compliance),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Export Options
          Text('Export Options', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Tooltip(
                message: 'Export as PDF',
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('📄 PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Tooltip(
                message: 'Export as Excel',
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.table_chart, size: 18),
                  label: const Text('Excel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Tooltip(
                message: 'Export as CSV',
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_present, size: 18),
                  label: const Text('CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Tooltip(
              message: 'Generate the selected report',
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Generate Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.accentCyan,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
