import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/medicine_provider.dart';
import 'add_medicine_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(medicineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Medicine Reminder")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddMedicineScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: meds.isEmpty
          ? const Center(
              child: Text(
                "No medicines added yet",
                style: TextStyle(color: Colors.teal, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: meds.length,
              itemBuilder: (_, i) {
                final m = meds[i];
                final time =
                    "${m.hour.toString().padLeft(2, '0')}:${m.minute.toString().padLeft(2, '0')}";
                return Card(
                  child: ListTile(
                    title: Text(m.name),
                    subtitle: Text("Dose: ${m.dose}"),
                    trailing: Text(
                      time,
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
