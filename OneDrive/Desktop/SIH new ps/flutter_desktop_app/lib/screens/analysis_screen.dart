import 'package:flutter/material.dart';
import '../widgets/progress_bar.dart';

class AnalysisScreen extends StatelessWidget {
  final sections = [
    {'name':'Executive Summary','compl':95,'quality':'Excellent','issues':0},
    {'name':'Cost Estimates','compl':76,'quality':'Fair','issues':4},
    // ... more
  ];

  Color _qualityColor(BuildContext context, String q) {
    switch(q.toLowerCase()){
      case 'excellent': return Colors.green;
      case 'good': return Theme.of(context).colorScheme.primary;
      case 'fair': return Colors.orange;
      case 'poor': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (_,i){
        final s=sections[i];
        return Card(
          margin: EdgeInsets.only(bottom:16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text(s['name'] as String, style: Theme.of(context).textTheme.headlineSmall),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:8,vertical:4),
                      decoration: BoxDecoration(color:_qualityColor(context, s['quality'] as String),borderRadius:BorderRadius.circular(12)),
                      child: Text(s['quality'] as String,style:const TextStyle(color:Colors.white))
                    )
                  ]
                ),
                SizedBox(height:8),
                Text('Issues: ${s['issues']}'),
                SizedBox(height:8),
                ProgressBar(percentage: (s['compl'] as int).toDouble(), color: _qualityColor(context, s['quality'] as String)),
              ]
            ),
          )
        );
      }
    );
  }
}
