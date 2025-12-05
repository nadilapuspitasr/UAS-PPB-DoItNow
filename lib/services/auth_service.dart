import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // ======================
  // REGISTER
  // ======================
  Future<AppUser> register({
    required String name,
    required String npm,
    required String major,
    required String email,
    required String password,
  }) async {
    // 1. REGISTER AUTH
    final res = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Register gagal. User tidak terbentuk.');
    }

    // 2. INSERT PROFILE (tanpa email)
    await _client.from('profiles').upsert({
      'id': user.id,
      'name': name,
      'npm': npm,
      'major': major,
    });

    return AppUser(
      id: user.id,
      email: email, // email tetap diambil dari auth
      name: name,
      npm: npm,
      major: major,
    );
  }

  // ======================
  // LOGIN
  // ======================
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Email atau password salah.');
    }

    // Ambil profile (aman, tidak error meski kosong)
    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return AppUser.fromMaps(
      authUser: {
        'id': user.id,
        'email': user.email,
      },
      profile: profile ?? {},
    );
  }

  // ======================
  // UPDATE PROFILE
  // ======================
  Future<void> updateProfile({
    required String name,
    required String npm,
    required String major,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    await _client.from('profiles').upsert({
      'id': user.id,
      'name': name,
      'npm': npm,
      'major': major,
    });
  }

  // ======================
  // GET CURRENT USER
  // ======================
  Future<AppUser?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return AppUser.fromMaps(
      authUser: {
        'id': user.id,
        'email': user.email,
      },
      profile: profile ?? {},
    );
  }

  // ======================
  // LOGOUT
  // ======================
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}