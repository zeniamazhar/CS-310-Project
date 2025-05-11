import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/app_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editing = false;
  bool _notificationsEnabled = false;
  bool _obscurePassword = true;

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _bioController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return;
    final data = doc.data()!;
    setState(() {
      _nameController.text = data['name'] ?? '';
      _usernameController.text = data['username'] ?? '';
      _emailController.text = user.email ?? '';
      _bioController.text = data['bio'] ?? '';
      _notificationsEnabled = data['notificationsEnabled'] ?? false;
    });
  }

  Future<void> _saveChanges() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Update password in Firebase Auth if provided
      if (_passwordController.text.isNotEmpty) {
        await user.updatePassword(_passwordController.text);
      }

      // Update Firestore profile data (excluding password)
      final updatedData = {
        'name': _nameController.text,
        'username': _usernameController.text,
        'bio': _bioController.text,
        'notificationsEnabled': _notificationsEnabled,
      };
      await _firestore.collection('users').doc(user.uid).update(updatedData);

      setState(() {
        _editing = false;
        _obscurePassword = true;
        _passwordController.clear(); // clear password field
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _cancelChanges() {
    // Reload original data
    _loadUserData();
    setState(() {
      _editing = false;
      _obscurePassword = true;
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageIndex: 2,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/movieList');
        }
      },
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: ListView(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.secondaryButtonColor,
                      child: Icon(Icons.person, size: 40, color: AppColors.secondaryColor),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        _nameController.text,
                        style: const TextStyle(color: AppColors.textColor, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!_editing)
                      ElevatedButton.icon(
                        onPressed: () => setState(() {
                          _editing = true;
                          _obscurePassword = true;
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkButtonColor,
                          foregroundColor: AppColors.darkButtonTextColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: AppColors.secondaryColor),
                        label: const Text('Edit'),
                      ),
                    if (_editing)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkButtonColor,
                                foregroundColor: AppColors.darkButtonTextColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Save Changes'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _cancelChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkButtonColor,
                                foregroundColor: AppColors.darkButtonTextColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    _buildField('Username', _usernameController),
                    const SizedBox(height: 10),
                    _buildField('Email', _emailController, enabled: false),
                    const SizedBox(height: 10),
                    _buildField(
                      'Password',
                      _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: _editing
                          ? IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.secondaryColor,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    _buildField('Biography', _bioController, maxLines: 3),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text(
                        'Notify upcoming movies',
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      activeColor: AppColors.darkButtonColor,
                      value: _notificationsEnabled,
                      onChanged: _editing
                          ? (val) => setState(() => _notificationsEnabled = val)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Log Out?'),
                        content: const Text('Do you want to log out and go back to the Welcome Page?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _auth.signOut();
                              Navigator.pop(ctx);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/welcome',
                                    (route) => false,
                              );
                            },
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkButtonColor,
                    foregroundColor: AppColors.darkButtonTextColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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

  Widget _buildField(
      String label,
      TextEditingController controller, {
        bool obscureText = false,
        int maxLines = 1,
        bool enabled = true,
        Widget? suffixIcon,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: _editing && enabled,
      style: const TextStyle(color: AppColors.secondaryTextColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.secondaryTextColor),
        filled: true,
        fillColor: AppColors.lightBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.textColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
