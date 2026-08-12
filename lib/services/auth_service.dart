import 'package:osrc_plus/models/user_model.dart';

class AuthService {
  // In-memory storage (for test/demo). Later switch to FirebaseAuth / Firestore.
  static final Map<String, String> _passwords = {
    'admin@test.com': '123456',
    'worker@test.com': '123456',
  };

  static final Map<String, UserModel> _users = {
    'admin@test.com': UserModel(
      id: 'admin@test.com',
      name: 'Admin',
      phone: '0000000000',
      role: 'admin',
      salaryPerDay: 0.0,
      assignedSite: null,
    ),
    'worker@test.com': UserModel(
      id: 'worker@test.com',
      name: 'Worker',
      phone: '1111111111',
      role: 'worker',
      salaryPerDay: 100.0,
      assignedSite: null,
    ),
  };

  static UserModel? _currentUser;

  static UserModel? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;

  // Current methods (existing)
  static bool login(String email, String password) {
    final key = email.trim().toLowerCase();
    if (_passwords.containsKey(key) && _passwords[key] == password) {
      _currentUser = _users[key];
      return true;
    }
    return false;
  }

  static bool register(String email, String password, {String role = 'worker', String name = ''}) {
    final key = email.trim().toLowerCase();
    if (key.isEmpty || password.isEmpty) return false;
    if (_passwords.containsKey(key)) return false;

    _passwords[key] = password;
    _users[key] = UserModel(
      id: key,
      name: name.isNotEmpty ? name : key.split('@').first,
      phone: '',
      role: role,
      salaryPerDay: 0.0,
      assignedSite: null,
    );
    return true;
  }

  static bool registerUser(UserModel user, String password) {
    final key = user.id.trim().toLowerCase();
    if (key.isEmpty || password.isEmpty) return false;
    if (_passwords.containsKey(key)) return false;

    _passwords[key] = password;
    _users[key] = user;
    return true;
  }

  static void logout() {
    _currentUser = null;
  }

  // New placeholder methods mapped to ready-to-use API names
  static Future<UserModel?> loginUser({required String email, required String password}) async {
    // TODO: swap for FirebaseAuth.instance.signInWithEmailAndPassword
    final user = await signInWithEmailAndPassword(email, password);
    return user;
  }

  static Future<UserModel?> registerUserWithEmail({
    required String email,
    required String password,
    required String role,
    required String name,
  }) async {
    // TODO: swap for Firebase Auth + Firestore user profile document creation
    return registerWithEmailAndPassword(email: email, password: password, role: role, name: name);
  }

  static Future<void> logoutUser() async {
    // TODO: swap for FirebaseAuth.instance.signOut
    logout();
  }

  // Adapter methods; keep old names for compatibility.
  static Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    final success = login(email, password);
    return success ? _users[email.trim().toLowerCase()] : null;
  }

  static Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String role,
    String name = '',
  }) async {
    final ok = register(email, password, role: role, name: name);
    return ok ? _users[email.trim().toLowerCase()] : null;
  }

  static String? get role => _currentUser?.role;
}
