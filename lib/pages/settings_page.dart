import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  double _fontSize = 16;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
      _fontSize = _prefs?.getDouble('fontSize') ?? 16.0;
    });
  }

  void _onThemeChanged(bool value) {
    setState(() {
      _isDarkMode = value;
      _prefs?.setBool('isDarkMode', value);
    });
  }

  void _onFontSizeChanged(double value) {
    setState(() {
      _fontSize = value;
      _prefs?.setDouble('fontSize', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Настройки',
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
                    'Темный режим (Dark mode)',
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
                  const Text('Размер шрифта', style: TextStyle(fontSize: 16)),
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
                      const Text('Маленький'),
                      Text('${_fontSize.toStringAsFixed(0)} px'),
                      const Text('Большой'),
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
