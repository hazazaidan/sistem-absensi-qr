class AbsensiModel {
  final int no;
  final String nis;
  final String nama;
  final String status;
  final String jamMasuk;
  final String jamPulang;
  final String keterangan;

  AbsensiModel({
    required this.no,
    required this.nis,
    required this.nama,
    required this.status,
    required this.jamMasuk,
    required this.jamPulang,
    this.keterangan = '-',
  });
}

final List<AbsensiModel> dummyAbsensi = [
  AbsensiModel(no: 1, nis: '0146886', nama: 'Almira Pratiwi', status: 'Hadir', jamMasuk: '06:54:00', jamPulang: '14:49:00'),
  AbsensiModel(no: 2, nis: '4290352', nama: 'Candra Dabukke', status: 'Hadir', jamMasuk: '07:14:00', jamPulang: '14:33:00'),
  AbsensiModel(no: 3, nis: '1234567', nama: 'Ferdy Pepey', status: 'Hadir', jamMasuk: '06:11:00', jamPulang: '15:33:00'),
  AbsensiModel(no: 4, nis: '1303733', nama: 'Garang Nababan', status: 'Hadir', jamMasuk: '06:02:00', jamPulang: '14:19:00'),
  AbsensiModel(no: 5, nis: '3456789', nama: 'Lukas', status: 'Hadir', jamMasuk: '07:41:00', jamPulang: '15:18:00'),
  AbsensiModel(no: 6, nis: '1234567', nama: 'Robi Ramlan', status: 'Hadir', jamMasuk: '06:14:00', jamPulang: '14:01:00'),
  AbsensiModel(no: 7, nis: '7901233', nama: 'Toggo', status: 'Hadir', jamMasuk: '06:48:00', jamPulang: '15:27:00'),
  AbsensiModel(no: 8, nis: '0333958', nama: 'Zahra Safitri', status: 'Izin', jamMasuk: '-', jamPulang: '-', keterangan: 'Ada keperluan keluarga'),
];