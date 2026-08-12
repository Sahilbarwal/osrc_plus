import 'package:flutter/foundation.dart';
import 'package:osrc_plus/models/user_model.dart';
import 'package:osrc_plus/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _loading = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get loading => _loading;

  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    // Keep synchronous backend for now; future Firebase flow in AuthService.
    final user = await AuthService.signInWithEmailAndPassword(email, password);
    _user = user;

    _loading = false;
    notifyListeners();
    return user != null;
  }

  Future<bool> register({required String email, required String password, required String role, required String name}) async {
    _loading = true;
    notifyListeners();

    final user = await AuthService.registerWithEmailAndPassword(email: email, password: password, role: role, name: name);
    if (user != null) {
      _user = user;
    }

    _loading = false;
    notifyListeners();
    return user != null;
  }

  void logout() {
    AuthService.logout();
    _user = null;
    notifyListeners();
  }
}