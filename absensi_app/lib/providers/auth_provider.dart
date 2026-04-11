import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? user;

  Future<void> login(String nis, String password, BuildContext context) async {
    user = await _service.login(nis, password);
    notifyListeners();

    Navigator.pushReplacementNamed(context, '/dashboard');
  }
}