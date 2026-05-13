import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/suhu_provider.dart';
import '../widgets/hasil_item.dart';

class KonversiSuhuPage extends StatelessWidget {
  const KonversiSuhuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final suhu = context.watch<SuhuProvider>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Suhu'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  user.email?.split('@').first ?? 'User',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Input
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Masukkan suhu',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      context.read<SuhuProvider>().setInput(value);
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    initialValue: suhu.satuanInput, // ← PERBAIKI: value diganti initialValue
                    decoration: const InputDecoration(
                      labelText: 'Pilih satuan',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Celcius', 'Fahrenheit', 'Kelvin', 'Reamur']
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context.read<SuhuProvider>().setSatuan(value!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Hasil
            Expanded(
              child: ListView(
                children: [
                  HasilItem(
                    title: 'Celcius',
                    value: suhu.format(suhu.celcius),
                    unit: '°C',
                  ),
                  const Divider(),
                  HasilItem(
                    title: 'Fahrenheit',
                    value: suhu.format(suhu.fahrenheit),
                    unit: '°F',
                  ),
                  const Divider(),
                  HasilItem(
                    title: 'Kelvin',
                    value: suhu.format(suhu.kelvin),
                    unit: 'K',
                  ),
                  const Divider(),
                  HasilItem(
                    title: 'Reamur',
                    value: suhu.format(suhu.reamur),
                    unit: '°R',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}