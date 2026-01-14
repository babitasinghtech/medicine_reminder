import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';

class MedicineNotifier extends StateNotifier<List<Medicine>> {
  MedicineNotifier() : super([]) {
    load();
  }

  void load() {
    state = StorageService.getAll()
      ..sort(
        (a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute),
      );
  }

  Future addMedicine(Medicine m) async {
    await StorageService.add(m);
    load();
  }

  Future updateMedicine(Medicine oldMed, Medicine newMed) async {
    await oldMed.delete();
    await StorageService.add(newMed);
    load();
  }
}

final medicineProvider =
    StateNotifierProvider<MedicineNotifier, List<Medicine>>(
      (ref) => MedicineNotifier(),
    );
