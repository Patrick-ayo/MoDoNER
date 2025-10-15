import 'package:flutter/material.dart';
import '../theme.dart';

class ProjectLogItem extends StatelessWidget {
  final String name;
  final String id;
  final String riskLevel;
  final int progress; // 0-100
  final String submissionDate;
  final VoidCallback? onTap; // FIX: Added the onTap parameter

  const ProjectLogItem({
    super.key,
    required this.name,
    required this.id,
    required this.riskLevel,
    required this.progress,
    required this.submissionDate,
    this.onTap, // FIX: Added onTap to the constructor
  });

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high risk':
        return AppTheme.error;
      case 'medium risk':
        return AppTheme.warning;
      case 'low risk':
        return AppTheme.success;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRiskTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
  color: _getRiskColor(riskLevel).withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getRiskColor(riskLevel), width: 1),
      ),
      child: Text(
        riskLevel,
        style: TextStyle(
          color: _getRiskColor(riskLevel),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // FIX: Wrapped the Card's content in an InkWell and assigned the onTap callback
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Make the left column expand and truncate to avoid overflow
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(id, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildRiskTag(context),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress / 100.0,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
                backgroundColor: Theme.of(context).dividerColor.withAlpha((0.1 * 255).round()),
                color: AppTheme.primaryLight,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Latest submission: $submissionDate',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).textTheme.bodySmall?.color),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}