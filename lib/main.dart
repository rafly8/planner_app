import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import Lokalisasi Ditambahkan
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_config.dart';
import 'providers/target_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Inisialisasi Service Notifikasi
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TargetProvider())],
      child: MaterialApp(
        title: 'Target Planner',
        debugShowCheckedModeBanner: false,
        // Delegasi Lokalisasi Ditambahkan
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        ),
        home: session != null ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
