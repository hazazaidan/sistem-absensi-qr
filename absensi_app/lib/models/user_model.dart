class UserModel {
  final String nama;
  final String nis;
  final String kelas;
  final String email;
  final String jurusan;
  final String noHpOrtu;

  UserModel({
    required this.nama,
    required this.nis,
    required this.kelas,
    required this.email,
    required this.jurusan,
    required this.noHpOrtu,
  });
}

final UserModel dummyUser = UserModel(
  nama: 'Andi Saputra',
  nis: '123456',
  kelas: 'XI RPL 1',
  email: 'andi.saputra@siswa.sch.id',
  jurusan: 'Rekayasa Perangkat Lunak',
  noHpOrtu: '082318769878',
);