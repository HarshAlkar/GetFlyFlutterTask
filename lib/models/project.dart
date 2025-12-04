import 'package:flutter/foundation.dart';

class Project {
  final String id;
  final String name;
  final String status; // e.g., Active, On Hold, Completed
  final DateTime startDate;

  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.startDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'startDate': startDate.toIso8601String(),
      };

  @override
  String toString() => 'Project($name)';
}
