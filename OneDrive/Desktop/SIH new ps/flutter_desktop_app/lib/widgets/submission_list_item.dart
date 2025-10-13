import 'package:flutter/material.dart';
import '../theme.dart';

class SubmissionListItem extends StatelessWidget {
  final int index;
  final String name;
  final int riskScore; // Changed from 'status' to 'riskScore'

  const SubmissionListItem({
    super.key,
    required this.index,
    required this.name,
    required this.riskScore, // Updated parameter
  });

  // Helper to get a color based on the risk score
  Color _getRiskColor(int score) {
    if (score > 75) {
      return AppTheme.error; // High risk
    } else if (score > 50) {
      return AppTheme.warning; // Medium risk
    } else {
      return AppTheme.success; // Low risk
    }
  }

  // Helper to get a text label based on the risk score
  String _getRiskLabel(int score) {
    if (score > 75) {
      return 'High Risk';
    } else if (score > 50) {
      return 'Medium Risk';
    } else {
      return 'Low Risk';
    }
  }

  // Renamed helper to build the visual risk indicator
  Widget _buildRiskIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _getRiskColor(riskScore),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _getRiskLabel(riskScore), // Use the new risk label
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getRiskColor(riskScore),
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () {
          // TODO: Handle navigation to the project details screen
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    _buildRiskIndicator(context), // Updated to show risk
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.bookmark_border, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}