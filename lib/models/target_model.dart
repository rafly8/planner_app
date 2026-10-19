class TargetModel {
  final String id;
  final String userId;
  final String title;
  final String category;
  final DateTime? deadline;
  final String notes;

  TargetModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    this.deadline,
    required this.notes,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'category': category,
      'deadline': deadline?.toIso8601String(),
      'notes': notes,
    };
  }
}
