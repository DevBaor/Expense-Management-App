import 'package:firebase_core/firebase_core.dart';

class FirebaseBase {
  static Future<void> init() async {
    await Firebase.initializeApp();
  }
}
