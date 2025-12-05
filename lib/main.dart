// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme.dart';
import 'pages/auth/auth_gate.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dwanqkxuwrwcvqifprdz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3YW5xa3h1d3J3Y3ZxaWZwcmR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNjUxODcsImV4cCI6MjA3OTk0MTE4N30.lb5P75yUCv9IiZ5i16-178uvfU5KNCPM-P7KBZ4tcg8',                   // ganti
  );

  runApp(const DoItNowApp());
}

class DoItNowApp extends StatelessWidget {
  const DoItNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'DoItNow',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const AuthGate(),
      ),
    );
  }
}
