class CampusTaskModel {
  final String id;
  final String targetId;
  final String title;
  final String? notes;
  final DateTime? deadline;
  final bool isDone;
  final DateTime? completedAt;

  CampusTaskModel({
    required this.id,
    required this.targetId,
    required this.title,
    this.notes,
    this.deadline,
    this.isDone = false,
    this.completedAt,
  });

  factory CampusTaskModel.fromJson(Map<String, dynamic> json) {
    return CampusTaskModel(
      id: json['id'] ?? '',
      targetId: json['target_id'] ?? '',
      title: json['title'] ?? '',
      notes: json['notes'],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      isDone: json['is_done'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target_id': targetId,
      'title': title,
      'notes': notes,
      'deadline': deadline?.toIso8601String(),
      'is_done': isDone,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
