// lib/models/task.dart
class Task {
  final String id;
  final String title;
  final String? description;
  final String? course;
  final String priority; // low / medium / high
  final DateTime? deadline;
  final String status;   // todo / in_progress / done

  Task({
    required this.id,
    required this.title,
    this.description,
    this.course,
    required this.priority,
    this.deadline,
    required this.status,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      course: map['course'] as String?,
      priority: map['priority'] as String,
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'] as String)
          : null,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toInsertMap(String userId) {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'course': course,
      'priority': priority,
      'deadline': deadline?.toIso8601String(),
      'status': status,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title,
      'description': description,
      'course': course,
      'priority': priority,
      'deadline': deadline?.toIso8601String(),
      'status': status,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? course,
    String? priority,
    DateTime? deadline,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      course: course ?? this.course,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
    );
  }
}
