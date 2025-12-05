// lib/pages/auth/register_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _npmCtrl = TextEditingController();
  final _majorCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'DoItNow',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E5C56),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Buat Akun Mahasiswa',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 28),

                // CARD REGISTER
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black12,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                            ),
                          ),
                          const SizedBox(height: 18),

                          _inputField(
                            controller: _nameCtrl,
                            hint: 'Nama Lengkap',
                            icon: Icons.person_outline,
                            validator: (v) =>
                            v == null || v.isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          _inputField(
                            controller: _npmCtrl,
                            hint: 'NPM',
                            icon: Icons.badge_outlined,
                            validator: (v) =>
                            v == null || v.isEmpty
                                ? 'NPM wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          _inputField(
                            controller: _majorCtrl,
                            hint: 'Jurusan',
                            icon: Icons.school_outlined,
                            validator: (v) =>
                            v == null || v.isEmpty
                                ? 'Jurusan wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          _inputField(
                            controller: _emailCtrl,
                            hint: 'Email',
                            icon: Icons.email_outlined,
                            validator: (v) =>
                            v == null || !v.contains('@')
                                ? 'Email tidak valid'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          _inputField(
                            controller: _passwordCtrl,
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            obscure: true,
                            validator: (v) =>
                            v == null || v.length < 6
                                ? 'Minimal 6 karakter'
                                : null,
                          ),
                          const SizedBox(height: 22),

                          // BUTTON DAFTAR
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: auth.loading
                                  ? null
                                  : () async {
                                if (!_formKey.currentState!.validate())
                                  return;

                                try {
                                  await auth.register(
                                    name: _nameCtrl.text.trim(),
                                    npm: _npmCtrl.text.trim(),
                                    major: _majorCtrl.text.trim(),
                                    email: _emailCtrl.text.trim(),
                                    password:
                                    _passwordCtrl.text.trim(),
                                  );

                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Akun berhasil dibuat, silakan login')),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                        content:
                                        Text('Gagal daftar: $e')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF0E5C56),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                auth.loading ? 'Memproses...' : 'Daftar',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // BUTTON KEMBALI LOGIN
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Sudah punya akun? Login',
                              style: TextStyle(
                                color: Color(0xFF0E5C56),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF1F5F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _npmCtrl.dispose();
    _majorCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
