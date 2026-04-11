import '../models/user_model.dart';

class AuthService {
  Future<UserModel> login(String nis, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      nama: "Siswa Demo",
      nis: nis,
      kelas: "XI RPL",
      email: "demo@siswa.com",
      jurusan: "RPL",
      noHpOrtu:"082318769878",
    );
  }
}