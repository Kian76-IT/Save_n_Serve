class SessionService {
  static String? _token;
  static String? _userId;
  static String? _role;
  static String? _fullName;
  static String? _email;

  static String? get token => _token;
  static String? get userId => _userId;
  static String? get role => _role;
  static String? get fullName => _fullName;
  static String? get email => _email;

  static bool get isLoggedIn => _token != null;

  static void save({
    required String token,
    required String userId,
    required String role,
    required String fullName,
    required String email,
  }) {
    _token = token;
    _userId = userId;
    _role = role;
    _fullName = fullName;
    _email = email;
  }

  static void clear() {
    _token = null;
    _userId = null;
    _role = null;
    _fullName = null;
    _email = null;
  }
}
