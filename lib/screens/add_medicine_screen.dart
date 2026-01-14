import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medicine.dart';
import '../providers/medicine_provider.dart';
import '../services/notification_service.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  final Medicine? medicine;

  const AddMedicineScreen({super.key, this.medicine});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _name = TextEditingController();
  final _dose = TextEditingController();
  TimeOfDay? _time;

  bool get isEdit => widget.medicine != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final med = widget.medicine!;
      _name.text = med.name;
      _dose.text = med.dose;
      _time = TimeOfDay(hour: med.hour, minute: med.minute);
    }
  }

  void _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (t != null) setState(() => _time = t);
  }

  void _save() async {
    if (_name.text.isEmpty || _dose.text.isEmpty || _time == null) return;

    final now = DateTime.now();
    final schedule = DateTime(
      now.year,
      now.month,
      now.day,
      _time!.hour,
      _time!.minute,
    );

    if (isEdit) {
      final oldMed = widget.medicine!;

      final updatedMed = Medicine(
        name: _name.text,
        dose: _dose.text,
        hour: _time!.hour,
        minute: _time!.minute,
        alarmId: oldMed.alarmId,
      );

      await ref
          .read(medicineProvider.notifier)
          .updateMedicine(oldMed, updatedMed);

      await updateAlarm(updatedMed, _time!);
    } else {
      final alarmId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final med = Medicine(
        name: _name.text,
        dose: _dose.text,
        hour: _time!.hour,
        minute: _time!.minute,
        alarmId: alarmId,
      );

      await ref.read(medicineProvider.notifier).addMedicine(med);

      await NotificationService.scheduleOrUpdateAlarm(
        id: alarmId,
        title: "Medicine Reminder",
        body: "Take ${med.name} (${med.dose})",
        time: schedule,
      );
    }

    Navigator.pop(context);
  }

  Future updateAlarm(Medicine med, TimeOfDay newTime) async {
    final now = DateTime.now();
    final newSchedule = DateTime(
      now.year,
      now.month,
      now.day,
      newTime.hour,
      newTime.minute,
    );

    await NotificationService.cancelAlarm(med.alarmId);

    await NotificationService.scheduleOrUpdateAlarm(
      id: med.alarmId,
      title: "Medicine Reminder",
      body: "Take ${med.name} (${med.dose})",
      time: newSchedule,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Medicine" : "Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: "Medicine Name"),
            ),
            TextField(
              controller: _dose,
              decoration: const InputDecoration(labelText: "Dose"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _time == null
                      ? "No time selected"
                      : "Time: ${_time!.format(context)}",
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: _pickTime,
                  child: const Text("Pick Time"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: _save,
              child: Text(isEdit ? "Update Medicine" : "Save Medicine"),
            ),
          ],
        ),
      ),
    );
  }
}
