import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/project_log_item.dart';
import 'project_details_screen.dart';
import '../widgets/report_generator_popup.dart'; 

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

  void _showReportGeneratorPopup() {
  showDialog(
    context: context,
    builder: (context) => const ReportGeneratorPopup(),
  );
}


  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    final d = date.toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

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
                  isExpanded: true,
                  isDense: true,
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
                  isExpanded: true,
                  isDense: true,
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
                  isExpanded: true,
                  isDense: true,
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
          const SizedBox(height: 16),
          // Active Filters Display
          if (selectedDate != null ||
              selectedStatus != TaskStatus.all ||
              selectedSector != 'All' ||
              selectedRiskLevel != RiskLevel.all)
            Card(
              color: AppTheme.accentCyan.withAlpha((0.1 * 255).round()),
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
                onPressed: _showReportGeneratorPopup,
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

// --- WIDGET FOR TAB 2: PROJECT LOGS ---
class ProjectLogsView extends StatefulWidget {
  const ProjectLogsView({super.key});
  @override
  State<ProjectLogsView> createState() => _ProjectLogsViewState();
}

class _ProjectLogsViewState extends State<ProjectLogsView> {
  // Filter state variables
  String searchQuery = '';
  Timer? _searchDebounce;
  DateTime? selectedDate;
  TaskStatus selectedStatus = TaskStatus.all;
  String selectedSector = 'All';
  RiskLevel selectedRiskLevel = RiskLevel.all;
  final List<TaskStatus> statusOptions = const [TaskStatus.all, TaskStatus.todo, TaskStatus.ongoing, TaskStatus.completed];
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
  late final List<String> sectorOptions;
  final List<RiskLevel> riskLevelOptions = const [RiskLevel.all, RiskLevel.high, RiskLevel.medium, RiskLevel.low];

  final List<Map<String, dynamic>> projectLogs = [
  {
    'name': 'NH-37 Highway Extension',
    'id': 'DPR-2024-158',
    'riskLevel': 'High Risk',
    'progress': 42,
    'submissionDate': 'Oct 12, 2025',
    'sector': 'Roads & Bridges',
    'location': 'Guwahati to Dimapur',
    'budget': '₹450 Cr'
  },
  {
    'name': 'Tawang District Hospital',
    'id': 'DPR-2024-142',
    'riskLevel': 'Low Risk',
    'progress': 88,
    'submissionDate': 'Oct 08, 2025',
    'sector': 'Health Facilities',
    'location': 'Tawang, Arunachal Pradesh',
    'budget': '₹125 Cr'
  },
  {
    'name': 'Kaziranga Eco-Tourism Project',
    'id': 'DPR-2024-139',
    'riskLevel': 'Low Risk',
    'progress': 95,
    'submissionDate': 'Oct 05, 2025',
    'sector': 'Eco-Tourism & Sustainable Tourism',
    'location': 'Kaziranga, Assam',
    'budget': '₹85 Cr'
  },
  {
    'name': 'Shillong Smart City Water Network',
    'id': 'DPR-2024-131',
    'riskLevel': 'Medium Risk',
    'progress': 67,
    'submissionDate': 'Sep 28, 2025',
    'sector': 'Water Supply & Sanitation',
    'location': 'Shillong, Meghalaya',
    'budget': '₹220 Cr'
  },
  {
    'name': 'Imphal Irrigation Project',
    'id': 'DPR-2024-127',
    'riskLevel': 'High Risk',
    'progress': 34,
    'submissionDate': 'Sep 22, 2025',
    'sector': 'Irrigation & Flood Control',
    'location': 'Imphal Valley, Manipur',
    'budget': '₹380 Cr'
  },
  {
    'name': 'Aizawl Digital Data Center',
    'id': 'DPR-2024-118',
    'riskLevel': 'Low Risk',
    'progress': 92,
    'submissionDate': 'Sep 15, 2025',
    'sector': 'Digital Connectivity & Data Centers',
    'location': 'Aizawl, Mizoram',
    'budget': '₹95 Cr'
  },
  {
    'name': 'Kohima Heritage Preservation',
    'id': 'DPR-2024-112',
    'riskLevel': 'Medium Risk',
    'progress': 58,
    'submissionDate': 'Sep 10, 2025',
    'sector': 'Heritage & Cultural Preservation',
    'location': 'Kohima, Nagaland',
    'budget': '₹165 Cr'
  },
  {
    'name': 'Agartala Solar Power Grid',
    'id': 'DPR-2024-105',
    'riskLevel': 'High Risk',
    'progress': 28,
    'submissionDate': 'Sep 02, 2025',
    'sector': 'Green Energy & Climate Resilience',
    'location': 'Agartala, Tripura',
    'budget': '₹510 Cr'
  },
  {
    'name': 'Itanagar Border Road Construction',
    'id': 'DPR-2024-098',
    'riskLevel': 'High Risk',
    'progress': 15,
    'submissionDate': 'Aug 25, 2025',
    'sector': 'Border Roads & Helipads',
    'location': 'Itanagar, Arunachal Pradesh',
    'budget': '₹680 Cr'
  },
  {
    'name': 'Tura Watershed Management',
    'id': 'DPR-2024-089',
    'riskLevel': 'Low Risk',
    'progress': 78,
    'submissionDate': 'Aug 18, 2025',
    'sector': 'Watershed Management',
    'location': 'Tura, Meghalaya',
    'budget': '₹140 Cr'
  },
];


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
          title: const Text('Filter Project Logs'),
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
                  isExpanded: true,
                  isDense: true,
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
                  isExpanded: true,
                  isDense: true,
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
                  isExpanded: true,
                  isDense: true,
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search projects...',
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
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: _showFilterDialog,
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Active Filters Display
        if (selectedDate != null ||
            selectedStatus != TaskStatus.all ||
            selectedSector != 'All' ||
            selectedRiskLevel != RiskLevel.all)
          Card(
            color: AppTheme.accentCyan.withAlpha((0.1 * 255).round()),
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
        ...projectLogs.map((data) => ProjectLogItem(
      name: data['name'],
      id: data['id'],
      riskLevel: data['riskLevel'],
      progress: data['progress'],
      submissionDate: data['submissionDate'],
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProjectDetailsScreen(projectData: data),
          ),
        );
      },
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