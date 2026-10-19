import 'package:flutter/material.dart';

import '../models/target_model.dart';
import '../models/todo_model.dart';
import '../services/target_services.dart';

class TargetProvider with ChangeNotifier {
  final TargetService _targetService = TargetService();

  List<TargetModel> _targets = [];
  final Map<String, List<TodoModel>> _todosMap = {};
  bool _isLoading = false;

  List<TargetModel> get targets => _targets;
  bool get isLoading => _isLoading;

  List<TodoModel> getTodosForTarget(String targetId) {
    return _todosMap[targetId] ?? [];
  }

  // 1. FETCH SEMUA TARGET
  Future<void> fetchTargets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _targets = await _targetService.getTargets();
    } catch (e) {
      debugPrint('Error fetching targets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. TAMBAH TARGET BARU
  Future<void> addTarget(
    String title,
    String category,
    DateTime? deadline,
    String notes,
  ) async {
    await _targetService.addTarget(title, category, deadline, notes);
    await fetchTargets();
  }

  // 3. UPDATE TARGET
  Future<void> updateTarget(
    String id,
    String title,
    String category,
    DateTime? deadline,
    String notes,
  ) async {
    await _targetService.updateTarget(id, title, category, deadline, notes);
    await fetchTargets();
  }

  // 4. HAPUS TARGET
  Future<void> deleteTarget(String id) async {
    await _targetService.deleteTarget(id);
    _todosMap.remove(id);
    await fetchTargets();
  }

  // 5. FETCH TODO / CHECKLIST BERDASARKAN TARGET
  Future<void> fetchTodos(String targetId) async {
    try {
      final List<TodoModel> todos = await _targetService.getTodos(targetId);
      _todosMap[targetId] = todos;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching todos: $e');
    }
  }

  // 6. TAMBAH TODO BARU (DENGAN DUE_DATE)
  Future<void> addTodo(
    String targetId,
    String title, {
    DateTime? dueDate,
  }) async {
    await _targetService.addTodo(targetId, title, dueDate: dueDate);
    await fetchTodos(targetId);
  }

  // 7. TOGGLE STATUS CEKLIS TODO
  Future<void> toggleTodoStatus(
    String targetId,
    String todoId,
    bool currentStatus,
  ) async {
    await _targetService.toggleTodoStatus(todoId, currentStatus);
    await fetchTodos(targetId);
  }

  // 8. HAPUS TODO
  Future<void> deleteTodo(String targetId, String todoId) async {
    await _targetService.deleteTodo(todoId);
    await fetchTodos(targetId);
  }

  // HITUNG PROGRES TARGET (PERSENTASE CEKLIS)
  double getProgress(String targetId) {
    final todos = getTodosForTarget(targetId);
    if (todos.isEmpty) return 0.0;
    final doneCount = todos.where((todo) => todo.isDone).length;
    return doneCount / todos.length;
  }
}
