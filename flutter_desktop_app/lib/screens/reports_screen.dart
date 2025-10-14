import 'package:flutter/material.dart';
// ...existing imports...

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Reports & Analytics', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height:8),
          Text('Generate and export evaluation reports', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height:24),

          Text('Report Types', style: Theme.of(context).textTheme.headlineLarge),
          Wrap(spacing:8,children:[
            const ChoiceChip(label:Text('Individual Report'),selected:true),
            const ChoiceChip(label:Text('Monthly Summary'),selected:false),
            const ChoiceChip(label:Text('Comparative Analysis'),selected:false),
            const ChoiceChip(label:Text('Compliance Report'),selected:false),
          ]),

          const SizedBox(height:24),
          ElevatedButton(onPressed:(){},child: const Text('Generate Report')),
        ]
      ),
    );
  }
}
