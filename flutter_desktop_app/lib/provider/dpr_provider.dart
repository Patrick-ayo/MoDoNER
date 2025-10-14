import 'package:flutter/material.dart';
import '../models/dpr.dart';
import '../services/demo_loader.dart';

class DPRProvider extends ChangeNotifier {
  final List<DPR> _dprs = [];

  List<DPR> get dprs => List.unmodifiable(_dprs);

  Future<void> loadDemo() async {
    final loaded = await DemoLoader.loadDPRDemo();
    _dprs.clear();
    _dprs.addAll(loaded);
    notifyListeners();
  }

  void clear() {
    _dprs.clear();
    notifyListeners();
  }
}
