import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:nhom4/GUI/screens/authentication_screens/logintest.dart';
import 'package:nhom4/GUI/screens/authentication_screens/register_screen.dart';

class AccessScreen extends StatelessWidget {
  const AccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        leading: const CloseButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hình ảnh
            Image.asset('assets/images/ongtron.jpg', width: 200, height: 200),

            const SizedBox(height: 40),

            // Nút SIGN UP
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) =>
                        states.contains(MaterialState.pressed)
                            ? const Color(0xFF2FB49C)
                            : Colors.white,
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) =>
                        states.contains(MaterialState.pressed)
                            ? Colors.white
                            : const Color(0xFF2FB49C),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    wordSpacing: 2.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nút SIGN IN
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) =>
                        states.contains(MaterialState.pressed)
                            ? Colors.white
                            : const Color(0xFF2FB49C),
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) =>
                        states.contains(MaterialState.pressed)
                            ? const Color(0xFF2FB49C)
                            : Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    wordSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
