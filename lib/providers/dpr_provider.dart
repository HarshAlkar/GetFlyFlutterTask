import 'dart:collection';

import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/dpr.dart';

class DprProvider extends ChangeNotifier {
  // Mock auth state
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Static projects (hardcoded JSON-like list)
  final List<Project> _projects = [
    Project(
      id: 'p1',
      name: 'Metro Line Extension',
      status: 'Active',
      startDate: DateTime(2024, 11, 10),
    ),
    Project(
      id: 'p2',
      name: 'River Bridge Phase 2',
      status: 'On Hold',
      startDate: DateTime(2024, 9, 1),
    ),
    Project(
      id: 'p3',
      name: 'Industrial Park Roads',
      status: 'Active',
      startDate: DateTime(2025, 1, 5),
    ),
    Project(
      id: 'p4',
      name: 'Housing Complex Block A',
      status: 'Completed',
      startDate: DateTime(2024, 6, 15),
    ),
  ];

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  // DPR History (in-memory)
  final List<Dpr> _dprs = [];
  UnmodifiableListView<Dpr> get dprs => UnmodifiableListView(_dprs);
  List<Dpr> dprsByProject(String projectId) =>
      _dprs.where((d) => d.projectId == projectId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  // Mock login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (email.trim() == 'test@test.com' && password == '123456') {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Add DPR
  void addDpr(Dpr dpr) {
    _dprs.add(dpr);
    notifyListeners();
  }

  Project? findProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
