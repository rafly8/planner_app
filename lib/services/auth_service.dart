import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Inisialisasi Supabase Client
  final SupabaseClient supabase = Supabase.instance.client;

  // Fungsi Register (Daftar Akun)
  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  // Fungsi Login (Masuk Akun)
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Fungsi Logout (Keluar Akun)
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Cek ID User yang sedang aktif
  String? get currentUserId => supabase.auth.currentUser?.id;
}
