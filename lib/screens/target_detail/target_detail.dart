import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/target_model.dart';
import '../../models/todo_model.dart';
import '../../providers/target_provider.dart';

class TargetDetailScreen extends StatefulWidget {
  final TargetModel target;

  const TargetDetailScreen({super.key, required this.target});

  @override
  State<TargetDetailScreen> createState() => _TargetDetailScreenState();
}

class _TargetDetailScreenState extends State<TargetDetailScreen> {
  final TextEditingController _todoController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now();
  int? _filterMonth; // null = Semua Bulan

  final List<Map<String, dynamic>> _monthConfig = [
    {
      'name': 'Januari',
      'color': const Color(0xFF0284C7),
      'bg': const Color(0xFFE0F2FE),
    },
    {
      'name': 'Februari',
      'color': const Color(0xFFEC4899),
      'bg': const Color(0xFFFCE7F3),
    },
    {
      'name': 'Maret',
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFD1FAE5),
    },
    {
      'name': 'April',
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFEDE9FE),
    },
    {
      'name': 'Mei',
      'color': const Color(0xFF22C55E),
      'bg': const Color(0xFFDCFCE7),
    },
    {
      'name': 'Juni',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFEF3C7),
    },
    {
      'name': 'Juli',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEE2E2),
    },
    {
      'name': 'Agustus',
      'color': const Color(0xFF06B6D4),
      'bg': const Color(0xFFCFFAFE),
    },
    {
      'name': 'September',
      'color': const Color(0xFF6366F1),
      'bg': const Color(0xFFE0E7FF),
    },
    {
      'name': 'Oktober',
      'color': const Color(0xFFF97316),
      'bg': const Color(0xFFFFEDD5),
    },
    {
      'name': 'November',
      'color': const Color(0xFF14B8A6),
      'bg': const Color(0xFFCCFBF1),
    },
    {
      'name': 'Desember',
      'color': const Color(0xFF3B82F6),
      'bg': const Color(0xFFDBEAFE),
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TargetProvider>(
        context,
        listen: false,
      ).fetchTodos(widget.target.id);
    });
  }

  Future<void> _pickDueDate() async {
    int tempYear = _selectedDueDate.year;
    int tempMonth = _selectedDueDate.month;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 12,
              backgroundColor: const Color(0xFFFAFAFA),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _monthConfig[tempMonth - 1]['bg'],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: _monthConfig[tempMonth - 1]['color'],
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Pilih Bulan Target',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Color(0xFF94A3B8),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              color: Color(0xFF475569),
                            ),
                            onPressed: () => setModalState(() => tempYear--),
                          ),
                          Text(
                            '$tempYear',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF475569),
                            ),
                            onPressed: () => setModalState(() => tempYear++),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2.1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final isSelected = (index + 1) == tempMonth;
                          final config = _monthConfig[index];
                          final Color itemColor = config['color'];
                          final Color itemBg = config['bg'];

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  setModalState(() => tempMonth = index + 1),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? itemColor : itemBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? itemColor
                                        : itemColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  config['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : itemColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _monthConfig[tempMonth - 1]['color'],
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedDueDate = DateTime(tempYear, tempMonth, 1);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Terapkan Pilihan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetProvider = Provider.of<TargetProvider>(context);
    final rawTodos = targetProvider.getTodosForTarget(widget.target.id);

    // FILTERING BERDASARKAN BULAN
    final filteredTodos = rawTodos.where((todo) {
      if (_filterMonth == null) return true;
      if (todo.dueDate == null) return false;
      return todo.dueDate!.month == _filterMonth;
    }).toList();

    // SORTING BERDASARKAN TANGGAL
    final sortedTodos = List<TodoModel>.from(filteredTodos)
      ..sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });

    // PENGELOMPOKAN BERDASARKAN TAHUN
    final Map<String, List<TodoModel>> groupedByYear = {};
    for (var todo in sortedTodos) {
      final yearKey = todo.dueDate != null
          ? '${todo.dueDate!.year}'
          : 'Tanpa Batas Waktu';
      if (!groupedByYear.containsKey(yearKey)) {
        groupedByYear[yearKey] = [];
      }
      groupedByYear[yearKey]!.add(todo);
    }

    final progress = targetProvider.getProgress(widget.target.id);
    final selectedMonthConf = _monthConfig[_selectedDueDate.month - 1];

    return Scaffold(
      appBar: AppBar(title: Text(widget.target.title), elevation: 0),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CARD DASHBOARD UTAMA
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(widget.target.category),
                            backgroundColor: const Color(0xFFEFF6FF),
                            labelStyle: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.target.deadline != null)
                            Text(
                              'Deadline: ${DateFormat('dd MMM yyyy', 'id_ID').format(widget.target.deadline!)}',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      if (widget.target.notes.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          widget.target.notes,
                          style: const TextStyle(color: Color(0xFF475569)),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progres Checklist Target',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFF1F5F9),
                        color: const Color(0xFF2563EB),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // INPUT BAR CHECKLIST
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _todoController,
                          decoration: const InputDecoration(
                            hintText: 'Tambah item checklist baru...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _pickDueDate,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedMonthConf['bg'],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (selectedMonthConf['color'] as Color)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 16,
                                color: selectedMonthConf['color'],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat(
                                  'MMM yyyy',
                                  'id_ID',
                                ).format(_selectedDueDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: selectedMonthConf['color'],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: selectedMonthConf['color'],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF18181B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () async {
                          if (_todoController.text.trim().isEmpty) return;
                          await targetProvider.addTodo(
                            widget.target.id,
                            _todoController.text.trim(),
                            dueDate: _selectedDueDate,
                          );
                          _todoController.clear();
                        },
                        child: const Text('Tambah'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // BARIS HEADER DAFTAR CHECKLIST & DROPDOWN FILTER BULAN
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Checklist Target',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int?>(
                          value: _filterMonth,
                          hint: const Text(
                            'Filter Bulan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          icon: const Icon(
                            Icons.filter_alt_rounded,
                            size: 16,
                            color: Color(0xFF2563EB),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (val) {
                            setState(() {
                              _filterMonth = val;
                            });
                          },
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Semua Bulan'),
                            ),
                            ...List.generate(12, (i) {
                              return DropdownMenuItem<int?>(
                                value: i + 1,
                                child: Text(_monthConfig[i]['name']),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // TAMPILAN JIKA FILTER KOSONG
                if (groupedByYear.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.filter_alt_off_rounded,
                          size: 36,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _filterMonth != null
                              ? 'Tidak ada item checklist di bulan ${_monthConfig[_filterMonth! - 1]['name']}'
                              : 'Belum ada item checklist',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  // LIST CHECKLIST DIKELOMPOKKAN BERDASARKAN TAHUN
                  ...groupedByYear.entries.map((entry) {
                    final year = entry.key;
                    final yearTodos = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            bottom: 8,
                            top: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.folder_open_rounded,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                year == 'Tanpa Batas Waktu'
                                    ? year
                                    : 'Tahun $year',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${yearTodos.length}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: yearTodos.length,
                          itemBuilder: (context, index) {
                            final todo = yearTodos[index];
                            final todoMonthConf = todo.dueDate != null
                                ? _monthConfig[todo.dueDate!.month - 1]
                                : null;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: todo.isDone,
                                  activeColor: const Color(0xFF2563EB),
                                  onChanged: (val) {
                                    targetProvider.toggleTodoStatus(
                                      widget.target.id,
                                      todo.id,
                                      todo.isDone,
                                    );
                                  },
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: todo.isDone
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (todo.dueDate != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: todoMonthConf!['bg'],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                DateFormat(
                                                  'MMMM yyyy',
                                                  'id_ID',
                                                ).format(todo.dueDate!),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: todoMonthConf['color'],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (todo.isDone && todo.completedAt != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Selesai: ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(todo.completedAt!.toLocal())}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF16A34A),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    targetProvider.deleteTodo(
                                      widget.target.id,
                                      todo.id,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
