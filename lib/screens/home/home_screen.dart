import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/target_model.dart';
import '../../providers/target_provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../target_detail/target_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedFilterCategory = 'Semua';
  String _sortBy = 'Terbaru';

  final List<String> _categories = [
    'Semua',
    'Finansial',
    'Karir',
    'Edukasi',
    'Kesehatan',
    'Pribadi',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TargetProvider>(context, listen: false).fetchTargets(),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress == 1.0) return const Color(0xFF10B981);
    if (progress >= 0.5) return const Color(0xFF3B82F6);
    if (progress > 0) return const Color(0xFFF59E0B);
    return const Color(0xFF94A3B8);
  }

  void _showTargetDialog({TargetModel? targetToEdit}) {
    final titleController = TextEditingController(
      text: targetToEdit?.title ?? '',
    );
    final notesController = TextEditingController(
      text: targetToEdit?.notes ?? '',
    );
    String selectedCategory = targetToEdit?.category ?? 'Finansial';
    DateTime? selectedDeadline = targetToEdit?.deadline;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          targetToEdit == null
                              ? 'Tambah Target Baru'
                              : 'Edit Target',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Nama Target',
                        hintText: 'Misal: Tabungan Mobil Baru',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Kategori:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _categories.where((c) => c != 'Semua').map((
                        cat,
                      ) {
                        final isSelected = selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0F172A),
                          backgroundColor: const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF475569),
                          ),
                          onSelected: (bool selected) {
                            if (selected) {
                              setDialogState(() => selectedCategory = cat);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                            ),
                            label: Text(
                              selectedDeadline == null
                                  ? 'Atur Batas Waktu'
                                  : DateFormat('dd MMM yyyy')
                                        .format(selectedDeadline!),
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    selectedDeadline ??
                                    DateTime.now().add(
                                      const Duration(days: 30),
                                    ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null) {
                                setDialogState(() => selectedDeadline = picked);
                              }
                            },
                          ),
                        ),
                        if (selectedDeadline != null)
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () =>
                                setDialogState(() => selectedDeadline = null),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Catatan / Strategi (Opsional)',
                        hintText: 'Tulis strategi singkat...',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (titleController.text.isNotEmpty) {
                              final provider = Provider.of<TargetProvider>(
                                context,
                                listen: false,
                              );
                              if (targetToEdit == null) {
                                await provider.addTarget(
                                  titleController.text.trim(),
                                  selectedCategory,
                                  selectedDeadline,
                                  notesController.text.trim(),
                                );
                              } else {
                                await provider.updateTarget(
                                  targetToEdit.id,
                                  titleController.text.trim(),
                                  selectedCategory,
                                  selectedDeadline,
                                  notesController.text.trim(),
                                );
                              }
                              if (mounted) Navigator.pop(ctx);
                            }
                          },
                          child: Text(
                            targetToEdit == null ? 'Simpan Target' : 'Perbarui',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteTarget(TargetModel target) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Target?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${target.title}" beserta seluruh checklist-nya?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await Provider.of<TargetProvider>(
                context,
                listen: false,
              ).deleteTarget(target.id);
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final email = currentUser?.email ?? 'asik@gmail.com';
    final userName = email.split('@').first;
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'A';

    final targetProvider = Provider.of<TargetProvider>(context);

    var filteredList = targetProvider.targets.where((t) {
      final matchesSearch =
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedFilterCategory == 'Semua' ||
          t.category == _selectedFilterCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    if (_sortBy == 'Progres Tertinggi') {
      filteredList.sort(
        (a, b) => targetProvider
            .getProgress(b.id)
            .compareTo(targetProvider.getProgress(a.id)),
      );
    } else if (_sortBy == 'Mendekati Deadline') {
      filteredList.sort((a, b) {
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    }

    int totalTargets = targetProvider.targets.length;
    int completedTargets = targetProvider.targets
        .where((t) => targetProvider.getProgress(t.id) == 1.0)
        .length;
    double averageRatio = totalTargets > 0
        ? (completedTargets / totalTargets)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // TOP NAVBAR EXACT MATCH LIKE SCREENSHOT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.track_changes_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Planner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Dashboard Manajemen Target',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // SEARCH BAR
                  Container(
                    width: 260,
                    height: 38,
                    margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Cari target...',
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Color(0xFF94A3B8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // USER BADGE PERSIS SEPERTI GAMBAR
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(
                            initialLetter,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 12,
                                  color: Color(0xFF2563EB),
                                ),
                              ],
                            ),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // LOGOUT BUTTON
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    tooltip: 'Keluar',
                    onPressed: () async {
                      await AuthService().signOut();
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // MAIN BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1050),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BANNER WELCOME
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang Kembali, $userName!',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Kelola dan pantau progres seluruh target kamu di satu tempat.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => _showTargetDialog(),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text(
                                  'Target Baru',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // METRICS
                        Row(
                          children: [
                            _buildStatCard(
                              'Total Target',
                              '$totalTargets',
                              Icons.assignment_outlined,
                              const Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              'Target Selesai',
                              '$completedTargets',
                              Icons.check_circle_outline_rounded,
                              const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 46,
                                      height: 46,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: averageRatio,
                                            strokeWidth: 5,
                                            backgroundColor: const Color(
                                              0xFFF1F5F9,
                                            ),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(Color(0xFF8B5CF6)),
                                          ),
                                          Text(
                                            '${(averageRatio * 100).toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF8B5CF6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Progres Rata-rata',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        Text(
                                          'Pencapaian Total',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // FILTER & SORT BAR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _categories.map((cat) {
                                  final isSelected =
                                      _selectedFilterCategory == cat;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: FilterChip(
                                      label: Text(cat),
                                      selected: isSelected,
                                      selectedColor: const Color(0xFF0F172A),
                                      backgroundColor: Colors.white,
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF475569),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                          color: Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      onSelected: (_) => setState(
                                        () => _selectedFilterCategory = cat,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            DropdownButton<String>(
                              value: _sortBy,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w600,
                              ),
                              items:
                                  [
                                        'Terbaru',
                                        'Progres Tertinggi',
                                        'Mendekati Deadline',
                                      ]
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text('Urutkan: $s'),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _sortBy = val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // TARGET LIST
                        targetProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : filteredList.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(48),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Tidak ada target ditemukan.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredList.length,
                                itemBuilder: (ctx, index) {
                                  final target = filteredList[index];
                                  final progress = targetProvider.getProgress(
                                    target.id,
                                  );
                                  final progressColor = _getProgressColor(
                                    progress,
                                  );
                                  final isOverdue =
                                      target.deadline != null &&
                                      target.deadline!.isBefore(
                                        DateTime.now(),
                                      ) &&
                                      progress < 1.0;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TargetDetailScreen(
                                              target: target,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: progressColor
                                                            .withValues(
                                                              alpha: 0.12,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        Icons.flag_rounded,
                                                        color: progressColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 14),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          target.title,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                  0xFF0F172A,
                                                                ),
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 2,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    const Color(
                                                                      0xFFF1F5F9,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                target.category,
                                                                style: const TextStyle(
                                                                  fontSize: 11,
                                                                  color: Color(
                                                                    0xFF475569,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (target
                                                                    .deadline !=
                                                                null) ...[
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      isOverdue
                                                                      ? const Color(
                                                                          0xFFFEE2E2,
                                                                        )
                                                                      : const Color(
                                                                          0xFFF1F5F9,
                                                                        ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        6,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  'Deadline: ${DateFormat('dd MMM yyyy').format(target.deadline!)}',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color:
                                                                        isOverdue
                                                                        ? const Color(
                                                                            0xFFDC2626,
                                                                          )
                                                                        : const Color(
                                                                            0xFF475569,
                                                                          ),
                                                                    fontWeight:
                                                                        isOverdue
                                                                        ? FontWeight
                                                                              .bold
                                                                        : FontWeight
                                                                              .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 18,
                                                        color: Color(
                                                          0xFF64748B,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          _showTargetDialog(
                                                            targetToEdit:
                                                                target,
                                                          ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        size: 18,
                                                        color: Color(
                                                          0xFFEF4444,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          _confirmDeleteTarget(
                                                            target,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    child:
                                                        LinearProgressIndicator(
                                                          value: progress,
                                                          minHeight: 8,
                                                          backgroundColor:
                                                              const Color(
                                                                0xFFF1F5F9,
                                                              ),
                                                          color: progressColor,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Text(
                                                  '${(progress * 100).toStringAsFixed(0)}%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: progressColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
