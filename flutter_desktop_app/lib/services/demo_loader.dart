import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dpr.dart';

class DemoLoader {
  static Future<List<DPR>> loadDPRDemo() async {
    final raw = await rootBundle.loadString('assets/demo_data/dpr_demo.json');
    final List<dynamic> arr = json.decode(raw) as List<dynamic>;
    return arr.map((e) => DPR(
      id: e['id'] as String,
      title: e['title'] as String,
      type: e['type'] as String,
      state: e['state'] as String,
      submitDate: e['submitDate'] as String,
      status: e['status'] as String,
      completenessScore: (e['completenessScore'] as num).toInt(),
      qualityScore: (e['qualityScore'] as num).toInt(),
      riskLevel: e['riskLevel'] as String,
      budget: e['budget'] as String,
      notes: e['notes'] as String?,
    )).toList();
  }
}
