class DPR {
  final String id;
  final String title;
  final String type;
  final String state;
  final String submitDate;
  final String status;
  final int completenessScore;
  final int qualityScore;
  final String riskLevel;
  final String budget;
  final String? notes;

  DPR({
    required this.id,
    required this.title,
    required this.type,
    required this.state,
    required this.submitDate,
    required this.status,
    required this.completenessScore,
    required this.qualityScore,
    required this.riskLevel,
    required this.budget,
    this.notes,
  });
}

// Sample data
final List<DPR> sampleDPRs = [
  DPR(
    id: 'DPR001',
    title: 'NH-37 Highway Extension Project',
    type: 'Road Construction',
    state: 'Assam',
    submitDate: '2025-09-15',
    status: 'Under Review',
    completenessScore: 87,
    qualityScore: 82,
    riskLevel: 'Medium',
    budget: '₹450 Crores',
  ),
  // ... add additional DPRs
];
