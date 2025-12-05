import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  AppUser? currentUser;
  bool loading = false;

  // ======================
  // REGISTER
  // ======================
  Future<void> register({
    required String name,
    required String npm,
    required String major,
    required String email,
    required String password,
  }) async {
    _startLoading();

    try {
      debugPrint('REGISTER START');
      final user = await _service.register(
        name: name,
        npm: npm,
        major: major,
        email: email,
        password: password,
      );
      currentUser = user;
      debugPrint('REGISTER SUCCESS');
    } catch (e) {
      debugPrint('REGISTER ERROR: $e');
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  // ======================
  // LOGIN
  // ======================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _startLoading();

    try {
      debugPrint('LOGIN START');
      final user = await _service.login(
        email: email,
        password: password,
      );
      currentUser = user;
      debugPrint('LOGIN SUCCESS');
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  // ======================
  // UPDATE PROFILE
  // ======================
  Future<void> updateProfile({
    required String name,
    required String npm,
    required String major,
  }) async {
    _startLoading();

    try {
      await _service.updateProfile(
        name: name,
        npm: npm,
        major: major,
      );

      currentUser = currentUser?.copyWith(
        name: name,
        npm: npm,
        major: major,
      );

      debugPrint('PROFILE UPDATED');
    } catch (e) {
      debugPrint('UPDATE PROFILE ERROR: $e');
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  // ======================
  // LOGOUT
  // ======================
  Future<void> logout() async {
    await _service.logout();
    currentUser = null;
    notifyListeners();
  }

  // ======================
  // LOAD SESSION
  // ======================
  Future<void> loadSession() async {
    currentUser = await _service.getCurrentUser();
    notifyListeners();
  }

  // ======================
  // HELPER
  // ======================
  void _startLoading() {
    loading = true;
    notifyListeners();
  }

  void _stopLoading() {
    loading = false;
    notifyListeners();
  }
}
