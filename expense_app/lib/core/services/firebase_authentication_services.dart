import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:uuid/uuid.dart';
import 'package:nhom4/core/model/CategoryModel.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final Logger _logger = Logger();

  /// Đăng ký tài khoản mới với email & password
  Future<User?> signUp({
    required String email,
    required String password,
    required ApiService api,
  }) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = cred.user;
      if (user != null) {
        // Tạo map dữ liệu user để lưu SQLite
        Map<String, dynamic> userMap = {
          "id": user.uid,
          "username": user.displayName ?? user.email,
          "current_wallet_id": null,
        };
        await api.createUser(userMap);
        final List<Map<String, String>> _defaultCategoriesData = [
          {
            'name': 'Ăn uống',
            'type': 'expense',
            'icon_id': 'assets/icons/food.svg',
          },
          {
            'name': 'Di chuyển',
            'type': 'expense',
            'icon_id': 'assets/icons/travel.svg',
          },
          {
            'name': 'Giải trí',
            'type': 'expense',
            'icon_id': 'assets/icons/entertainment.svg',
          },
          {
            'name': 'Lương',
            'type': 'income',
            'icon_id': 'assets/icons/salary.svg',
          },
          {
            'name': 'Tiết kiệm',
            'type': 'income',
            'icon_id': 'assets/icons/bank.svg',
          },
        ];

        for (var item in _defaultCategoriesData) {
          // sinh id mới
          final newId = Uuid().v4();
          final cat = Category(
            id: newId,
            userId: user.uid,
            name: item['name'],
            type: item['type'],
            iconId: item['icon_id'],
          );
          // gửi lên server
          await api.createCategory(cat.toJson());
        }
      }
      return user;
    } on FirebaseAuthException catch (e) {
      _logger.e('SignUp failed: ${e.code} – ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected SignUp error: $e');
      rethrow;
    }
  }

  /// Đăng nhập với email & password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _logger.i('User signed in: ${cred.user?.email}');
      return cred.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('SignIn failed: ${e.code} – ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected SignIn error: $e');
      rethrow;
    }
  }

  /// Đăng nhập bằng tài khoản Google
  Future<User?> signInWithGoogle({required ApiService api}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.i('Người dùng đã hủy đăng nhập Google');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      var existingUser = await api.getUser(user!.uid);
      if (existingUser == null) {
        Map<String, dynamic> userMap = {
          "id": user.uid,
          "username": user.displayName ?? user.email,
          "current_wallet_id": null,
        };
        await api.createUser(userMap);
        final List<Map<String, String>> _defaultCategoriesData = [
          {
            'name': 'Ăn uống',
            'type': 'expense',
            'icon_id': 'assets/icons/food.svg',
          },
          {
            'name': 'Di chuyển',
            'type': 'expense',
            'icon_id': 'assets/icons/travel.svg',
          },
          {
            'name': 'Giải trí',
            'type': 'expense',
            'icon_id': 'assets/icons/entertainment.svg',
          },
          {
            'name': 'Lương',
            'type': 'income',
            'icon_id': 'assets/icons/salary.svg',
          },
          {
            'name': 'Tiết kiệm',
            'type': 'income',
            'icon_id': 'assets/icons/bank.svg',
          },
        ];

        for (var item in _defaultCategoriesData) {
          // sinh id mới
          final newId = Uuid().v4();
          final cat = Category(
            id: newId,
            userId: user.uid,
            name: item['name'],
            type: item['type'],
            iconId: item['icon_id'],
          );
          // gửi lên server
          await api.createCategory(cat.toJson());
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _logger.e('Google SignIn failed: ${e.code} – ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected Google SignIn error: $e');
      rethrow;
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _logger.i('User signed out');
    } catch (e) {
      _logger.e('SignOut error: $e');
      rethrow;
    }
  }

  /// Lắng nghe trạng thái thay đổi user (login/logout)
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Lấy user hiện tại
  User? get currentUser => _auth.currentUser;
}
