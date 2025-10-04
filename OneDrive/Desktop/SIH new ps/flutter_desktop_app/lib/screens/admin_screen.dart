import 'package:flutter/material.dart';
import '../widgets/metric_card.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('System Administration',style:Theme.of(context).textTheme.displayMedium),
          const SizedBox(height:8),
          Text('Manage users and settings',style:Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height:24),

          Text('System Overview', style: Theme.of(context).textTheme.headlineLarge),
          Wrap(spacing:8,children:[
            MetricCard(icon:Icons.cloud_done, title:'Uptime', value:'99.8%', borderColor:Colors.green),
            MetricCard(icon:Icons.person, title:'Active Users', value:'24', borderColor:Theme.of(context).colorScheme.primary),
            MetricCard(icon:Icons.queue, title:'Queue', value:'7', borderColor:Colors.orange),
            MetricCard(icon:Icons.storage, title:'Storage', value:'67%', borderColor:const Color(0xFF059669)),
          ]),

          const SizedBox(height:24),
          ElevatedButton(onPressed:()=>print('Backup'),child:const Text('Backup System')),
        ]
      )
    );
  }
}
