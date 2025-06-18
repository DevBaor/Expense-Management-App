import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/services/firebase_authentication_services.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/GUI/screens/home_screen/home_screen.dart';
import 'package:logger/logger.dart';
final _logger = Logger();
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthenticationService _authService =
      FirebaseAuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final User? user = await _authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (user != null) {
        // Đăng nhập thành công, hiển thị thông báo
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Chào mừng, ${user.email}!')));

        // Điều hướng đến HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đăng nhập thất bại. Kiểm tra thông tin.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = FirebaseAuthenticationService();

      final user = await authService.signInWithGoogle(api: ApiService());

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập với Google thành công: ${user.email}'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
       Logger().e('Lỗi khi đăng nhập Google: $e');
      setState(() {
        _errorMessage = 'Đăng nhập Google thất bại.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Nền đen
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                const SizedBox(height: 12),
                _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Column(
                      children: [
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(color: Color(0xFF2FB49C)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _loginWithGoogle,
                          icon: SuperIcon(
                            iconPath: 'assets/images/google.svg',
                            size: 24,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2FB49C),
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                          ),
                          label: Text(
                            'Đăng nhập với Google',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
