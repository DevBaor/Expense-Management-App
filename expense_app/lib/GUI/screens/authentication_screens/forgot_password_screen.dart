import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        leading: CloseButton(color: Colors.white),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Enter your email and we\'ll send you\ninstructions to reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          const SizedBox(height: 40),
          Form(
            key: formKey,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintText: 'Email',
                hintStyle: TextStyle(color: Color(0x70999999)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email can\'t be empty';
                } else if (!EmailValidator.validate(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
              onChanged: (value) => email = value,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Color(0xFF2FB49C)),
              onPressed: isLoading ? null : _submit,
              child:
                  isLoading
                      ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        "SEND RESET LINK",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    await Future.delayed(Duration(seconds: 2)); // giả lập gửi email

    // TODO: Gọi Firebase Auth reset password tại đây
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset link sent to $email'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() => isLoading = false);
  }
}
