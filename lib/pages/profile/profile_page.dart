import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController npmCtrl;
  late TextEditingController majorCtrl;
  late TextEditingController emailCtrl;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final user =
        Provider.of<AuthProvider>(context, listen: false).currentUser;

    nameCtrl = TextEditingController(text: user?.name ?? '');
    npmCtrl = TextEditingController(text: user?.npm ?? '');
    majorCtrl = TextEditingController(text: user?.major ?? '');
    emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFA),
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E5C56),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() => isEditing = !isEditing);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Belum login'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PROFILE CARD
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF0E5C56),
                      child:
                      Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 12),
                    _inputField('Nama Lengkap', nameCtrl),
                    _inputField('NPM', npmCtrl),
                    _inputField('Jurusan', majorCtrl),
                    _inputField('Email', emailCtrl, enabled: false),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // BUTTON SIMPAN
            if (isEditing)
      SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          await auth.updateProfile(
            name: nameCtrl.text.trim(),
            npm: npmCtrl.text.trim(),
            major: majorCtrl.text.trim(),
          );

          setState(() => isEditing = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A7F78), // lebih soft
          foregroundColor: Colors.white,
          elevation: 1.5,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Simpan Perubahan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      ),


    const SizedBox(height: 10),

            // LOGOUT
    SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
    onPressed: () async {
    await auth.logout();
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD9534F), // Soft Red
    foregroundColor: Colors.white,
    elevation: 1.5,
    shadowColor: Colors.black.withOpacity(0.15),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.logout, size: 20, color: Colors.white),
    SizedBox(width: 8),
    Text(
    'Logout',
    style: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        enabled: isEditing && enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor:
          isEditing && enabled ? Colors.white : Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
