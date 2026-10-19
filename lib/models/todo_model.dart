class TodoModel {
  final String id;
  final String targetId;
  final String title;
  final bool isDone;
  final DateTime? dueDate;
  final DateTime? completedAt; // 1. TAMBAHKAN FIELD INI

  TodoModel({
    required this.id,
    required this.targetId,
    required this.title,
    this.isDone = false,
    this.dueDate,
    this.completedAt, // 2. TAMBAHKAN DI KONSTRUKTOR
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] ?? '',
      targetId: json['target_id'] ?? '',
      title: json['title'] ?? '',
      isDone: json['is_done'] ?? false,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null, // 3. TAMBAHKAN BACA JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target_id': targetId,
      'title': title,
      'is_done': isDone,
      'due_date': dueDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(), // 4. TAMBAHKAN KE JSON
    };
  }
}
