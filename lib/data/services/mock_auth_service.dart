import 'dart:async';
import '../../domain/models/user.dart';

class MockAuthService {
  MockAuthService._private();
  static final MockAuthService instance = MockAuthService._private();

  // phone -> password
  final Map<String, String> _credentials = {
    '0612345678': 'password',
  };

  // phone -> name
  final Map<String, String> _names = {
    '0612345678': 'LINJOUOM Alain',
  };

  User? _current;

  User? get currentUser => _current;

  Future<User> login({required String phone, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final p = phone.trim();
    if (_credentials[p] == password) {
      final user = User(id: p, name: _names[p] ?? p, phone: p);
      _current = user;
      return user;
    }
    throw Exception('Identifiants invalides');
  }

  Future<User> register(
      {required String name,
      required String phone,
      required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final p = phone.trim();
    if (_credentials.containsKey(p)) throw Exception('Le numéro existe déjà');
    _credentials[p] = password;
    _names[p] = name;
    final user = User(id: p, name: name, phone: p);
    _current = user;
    return user;
  }

  void logout() {
    _current = null;
  }
}
