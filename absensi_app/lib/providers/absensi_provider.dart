import 'package:flutter/material.dart';
import '../models/absensi_model.dart';
import '../services/absensi_service.dart';

class AbsensiProvider extends ChangeNotifier {
  final AbsensiService _service = AbsensiService();

  List<AbsensiModel> data = [];

  Future<void> loadData() async {
    data = await _service.getData();
    notifyListeners();
  }
}