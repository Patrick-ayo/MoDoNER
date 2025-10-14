import 'package:flutter/material.dart';
import '../models/user.dart';

class AdminProvider extends ChangeNotifier {
  final List<User> _users = [
    User(id: 'u1', name: 'Alice Johnson', email: 'alice@example.com', role: 'Admin'),
    User(id: 'u2', name: 'Bob Smith', email: 'bob@example.com', role: 'Editor'),
    User(id: 'u3', name: 'Carol Lee', email: 'carol@example.com', role: 'Viewer'),
  ];

  // simple contact info
  String contactEmail = 'support@example.com';
  String contactPhone = '+1-555-123-4567';

  List<User> get users => List.unmodifiable(_users);

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void removeUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  void updateUserRole(String id, String newRole) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx].role = newRole;
      notifyListeners();
    }
  }

  // mock backup: return future that completes after delay
  Future<bool> performBackup() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // feedback submission (mock)
  Future<bool> submitFeedback(String fromEmail, String message) async {
    // In a real app, send to server. Here we log and pretend it worked.
    debugPrint('Feedback from $fromEmail: $message');
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  void updateContact({required String email, required String phone}) {
    contactEmail = email;
    contactPhone = phone;
    notifyListeners();
  }
}
