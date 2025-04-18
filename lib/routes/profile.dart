import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/user_data.dart';
import 'package:moveasy/utils/app_scaffold.dart';

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

  @override
  void initState() {
    super.initState();
    final user = UserData.getUserInfo(UserData.loggedInEmail!);
    _nameController = TextEditingController(text: user?['name'] ?? '');
    _usernameController = TextEditingController(text: user?['username'] ?? '');
    _emailController = TextEditingController(text: UserData.loggedInEmail ?? '');
    _passwordController = TextEditingController(text: user?['password'] ?? '');
    _bioController = TextEditingController(text: user?['bio'] ?? '');
    _notificationsEnabled = UserData.getNotificationPreference(UserData.loggedInEmail!);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageIndex: 2,
      onTap: (int index) {
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
                        label: const Text("Edit"),
                      ),
                    const SizedBox(height: 10),
                    _buildField("Username", _usernameController),
                    const SizedBox(height: 10),
                    _buildField("Email", _emailController, enabled: false),
                    const SizedBox(height: 10),
                    _buildField(
                      "Password",
                      _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: _editing
                          ? IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.secondaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    _buildField("Biography", _bioController, maxLines: 3),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text(
                        "Notify upcoming movies",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      activeColor: AppColors.darkButtonColor,
                      value: _notificationsEnabled,
                      onChanged: _editing
                          ? (val) {
                        setState(() => _notificationsEnabled = val);
                        UserData.setNotificationPreference(
                            UserData.loggedInEmail!, val);
                      }
                          : null,
                    ),
                    const SizedBox(height: 40),
                    if (_editing)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                foregroundColor: AppColors.buttonTextColor,
                              ),
                              onPressed: () {
                                final updatedUser = {
                                  'name': _nameController.text,
                                  'username': _usernameController.text,
                                  'password': _passwordController.text,
                                  'bio': _bioController.text,
                                };
                                UserData.updateUserInfo(
                                    UserData.loggedInEmail!, updatedUser);
                                setState(() {
                                  _editing = false;
                                  _obscurePassword = true;
                                });
                              },
                              child: const Text("Save Changes"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryButtonColor,
                                foregroundColor: AppColors.buttonTextColor,
                              ),
                              onPressed: () {
                                final user =
                                UserData.getUserInfo(UserData.loggedInEmail!);
                                setState(() {
                                  _nameController.text = user?['name'] ?? '';
                                  _usernameController.text = user?['username'] ?? '';
                                  _passwordController.text = user?['password'] ?? '';
                                  _bioController.text = user?['bio'] ?? '';
                                  _editing = false;
                                  _obscurePassword = true;
                                });
                              },
                              child: const Text("Cancel"),
                            ),
                          ),
                        ],
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
                        title: const Text("Log Out?"),
                        content: const Text(
                            "Do you want to log out and go back to the Welcome Page?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              UserData.setLoggedInEmail('');
                              Navigator.pop(ctx);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/welcome',
                                    (route) => false,
                              );
                            },
                            child: const Text("Log Out"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}
