import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/test_model.dart';
import '../models/variant_model.dart';
import 'dart:io';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox('settings');
    setState(() {
      _isDarkMode = box.get('isDarkMode', defaultValue: false);
      _fontSize = box.get('fontSize', defaultValue: 16.0);
    });
  }

  void _onThemeChanged(bool value) {
    setState(() {
      _isDarkMode = value;
      Hive.box('settings').put('isDarkMode', value);
    });
  }

  void _onFontSizeChanged(double value) {
    setState(() {
      _fontSize = value;
      Hive.box('settings').put('fontSize', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Sozlamalar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tungi rejim (Dark mode)',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(value: _isDarkMode, onChanged: _onThemeChanged),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shrift o\'lchami',
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 28,
                    divisions: 8,
                    label: _fontSize.toStringAsFixed(0),
                    onChanged: _onFontSizeChanged,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kichik'),
                      Text('${_fontSize.toStringAsFixed(0)} px'),
                      const Text('Katta'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
