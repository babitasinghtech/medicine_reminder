import 'package:hive/hive.dart';
import '../models/medicine.dart';

class StorageService {
  static const boxName = 'medicines';

  static Future init() async {
    Hive.registerAdapter(MedicineAdapter());
    await Hive.openBox<Medicine>(boxName);
  }

  static Box<Medicine> get box => Hive.box<Medicine>(boxName);

  static List<Medicine> getAll() => box.values.toList();

  static Future add(Medicine m) async => box.add(m);
}

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    throw UnimplementedError();
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    throw UnimplementedError();
  }
}
