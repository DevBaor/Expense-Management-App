import 'package:flutter/material.dart';
import 'package:nhom4/core/services/firebase_authentication_services.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:nhom4/core/API/API_Helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signUpWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("Mật khẩu và xác nhận mật khẩu không khớp");
      return;
    }

    setState(() => _loading = true);
    try {
      final authService = FirebaseAuthenticationService();
      final user = await authService.signUp(
        email: email,
        password: password,
        api: ApiService(),
      );
      if (user != null) {
        _showMessage("Đăng ký thành công: ${user.email}");
      }
    } catch (e) {
      _showMessage("Đăng ký thất bại: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      final authService = FirebaseAuthenticationService();
      final user = await authService.signInWithGoogle(api: ApiService());

      if (user != null) {
        _showMessage("Đăng nhập Google thành công: ${user.email}");
      }
    } catch (e) {
      _showMessage("Đăng nhập Google thất bại: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Đăng ký tài khoản")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.email, color: Color(0xFF2FB49C)),
              label: const Text(
                "Đăng ký",
                style: TextStyle(color: Color(0xFF2FB49C)),
              ),
              onPressed: _loading ? null : _signUpWithEmail,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(280, 40),
                backgroundColor: Colors.white, // Nền trắng
                foregroundColor: Color(
                  0xFF2FB49C,
                ), // Màu chữ (phòng khi dùng theme)
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: SuperIcon(iconPath: 'assets/images/google.svg', size: 24),
              label: const Text(
                "Đăng nhập với Google",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(280, 40),
                backgroundColor: Color(0xFF2FB49C), // Nền xanh
                foregroundColor: Colors.white, // Màu chữ/icon
              ),
              onPressed: _loading ? null : _signInWithGoogle,
            ),

            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
