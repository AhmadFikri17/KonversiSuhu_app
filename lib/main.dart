import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Konversi Suhu',
      debugShowCheckedModeBanner: false,
      home: KonversiSuhuPage(),
    );
  }
}

class KonversiSuhuPage extends StatefulWidget {
  const KonversiSuhuPage({super.key});

  @override
  State<KonversiSuhuPage> createState() => _KonversiSuhuPageState();
}

class _KonversiSuhuPageState extends State<KonversiSuhuPage> {
  final TextEditingController _inputController = TextEditingController();
  String _satuanInput = 'Celcius';

  // Hasil konversi
  double? _celcius;
  double? _fahrenheit;
  double? _kelvin;
  double? _reamur;

  final List<String> _satuanSuhu = [
    'Celcius',
    'Fahrenheit',
    'Kelvin',
    'Reamur',
  ];

  void _hitungKonversi() {
    String input = _inputController.text;

    if (input.isEmpty) {
      setState(() {
        _celcius = null;
        _fahrenheit = null;
        _kelvin = null;
        _reamur = null;
      });
      return;
    }

    double? nilai = double.tryParse(input);

    if (nilai == null) {
      setState(() {
        _celcius = null;
        _fahrenheit = null;
        _kelvin = null;
        _reamur = null;
      });
      return;
    }

    // Konversi ke Celcius dulu
    double c = 0;

    switch (_satuanInput) {
      case 'Celcius':
        c = nilai;
        break;
      case 'Fahrenheit':
        c = (nilai - 32) * 5 / 9;
        break;
      case 'Kelvin':
        c = nilai - 273.15;
        break;
      case 'Reamur':
        c = nilai * 5 / 4;
        break;
    }

    setState(() {
      _celcius = c;
      _fahrenheit = (c * 9/5) + 32;
      _kelvin = c + 273.15;
      _reamur = c * 4/5;
    });
  }

  String _formatAngka(double? nilai) {
    if (nilai == null) return '-';
    return nilai.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Suhu'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Masukkan suhu',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _hitungKonversi(),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    initialValue: _satuanInput,
                    decoration: const InputDecoration(
                      labelText: 'Pilih satuan',
                      border: OutlineInputBorder(),
                    ),
                    items: _satuanSuhu.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _satuanInput = newValue!;
                        _hitungKonversi();
                      });
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
                  _buildHasil('Celcius', _formatAngka(_celcius), '°C'),
                  const Divider(),
                  _buildHasil('Fahrenheit', _formatAngka(_fahrenheit), '°F'),
                  const Divider(),
                  _buildHasil('Kelvin', _formatAngka(_kelvin), 'K'),
                  const Divider(),
                  _buildHasil('Reamur', _formatAngka(_reamur), '°R'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasil(String title, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '$value $unit',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}