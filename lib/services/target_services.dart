import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/target_model.dart';
import '../models/todo_model.dart';

class TargetService {
  final SupabaseClient supabase = Supabase.instance.client;

  // 1. MENGAMBIL DAFTAR TARGET
  Future<List<TargetModel>> getTargets() async {
    final response = await supabase
        .from('targets')
        .select()
        .order('created_at', ascending: false);

    return List<TargetModel>.from(
      (response as List).map(
        (e) => TargetModel.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
  }

  // 2. MENAMBAHKAN TARGET BARU
  Future<void> addTarget(
    String title,
    String category,
    DateTime? deadline,
    String notes,
  ) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('targets').insert({
      'user_id': userId,
      'title': title,
      'category': category,
      'deadline': deadline?.toIso8601String(),
      'notes': notes,
    });
  }

  // 3. MENGEDIT / UPDATE TARGET
  Future<void> updateTarget(
    String id,
    String title,
    String category,
    DateTime? deadline,
    String notes,
  ) async {
    await supabase
        .from('targets')
        .update({
          'title': title,
          'category': category,
          'deadline': deadline?.toIso8601String(),
          'notes': notes,
        })
        .eq('id', id);
  }

  // 4. MENGHAPUS TARGET
  Future<void> deleteTarget(String id) async {
    await supabase.from('targets').delete().eq('id', id);
  }

  // 5. MENGAMBIL DAFTAR TODO / CHECKLIST BERDASARKAN TARGET
  Future<List<TodoModel>> getTodos(String targetId) async {
    final response = await supabase
        .from('todos')
        .select()
        .eq('target_id', targetId)
        .order('created_at', ascending: true);

    return List<TodoModel>.from(
      (response as List).map(
        (e) => TodoModel.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
  }

  // 6. MENAMBAH TODO BARU (DENGAN DUE_DATE)
  Future<void> addTodo(
    String targetId,
    String title, {
    DateTime? dueDate,
  }) async {
    await supabase.from('todos').insert({
      'target_id': targetId,
      'title': title,
      'is_done': false,
      'due_date': dueDate?.toIso8601String(),
    });
  }

  // 7. MENGUBAH STATUS CEKLIS TODO
  Future<void> toggleTodoStatus(String todoId, bool currentStatus) async {
    final bool newStatus = !currentStatus;
    await supabase
        .from('todos')
        .update({
          'is_done': newStatus,
          'completed_at': newStatus
              ? DateTime.now().toUtc().toIso8601String()
              : null, // Mengirim format UTC standar
        })
        .eq('id', todoId);
  }

  // 8. MENGHAPUS TODO
  Future<void> deleteTodo(String todoId) async {
    await supabase.from('todos').delete().eq('id', todoId);
  }
}
