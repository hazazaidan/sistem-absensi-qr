import '../models/absensi_model.dart';

class AbsensiService {
  Future<List<AbsensiModel>> getData() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      AbsensiModel(
        no: 1,
        nis: "123",
        nama: "Budi",
        status: "Hadir",
        jamMasuk: "07:00",
        jamPulang: "15:00",
      ),
      AbsensiModel(
        no: 2,
        nis: "124",
        nama: "Andi",
        status: "Izin",
        jamMasuk: "-",
        jamPulang: "-",
        keterangan: "Sakit",
      ),
    ];
  }
}