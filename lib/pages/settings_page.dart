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
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Внешний вид',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Темная тема'),
                      Switch(
                        value: _isDarkMode,
                        onChanged: _onThemeChanged,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
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
                    'Размер шрифта',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Маленький'),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12,
                          max: 20,
                          divisions: 8,
                          activeColor: Colors.green,
                          onChanged: _onFontSizeChanged,
                        ),
                      ),
                      const Text('Большой'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Пример текста',
                    style: TextStyle(fontSize: _fontSize),
                  ),
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
                    'О приложении',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.info, color: Colors.green),
                    title: Text('Версия'),
                    subtitle: Text('1.0.0'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.developer_mode, color: Colors.green),
                    title: Text('Разработчик'),
                    subtitle: Text('Variant Master Team'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.email, color: Colors.green),
                    title: Text('Email'),
                    subtitle: Text('support@variantmaster.com'),
                  ),
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
                    'Функции',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.quiz, color: Colors.green),
                    title: Text('Добавление тестов'),
                    subtitle: Text('Создавайте тесты по различным предметам'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.picture_as_pdf, color: Colors.green),
                    title: Text('Создание вариантов'),
                    subtitle: Text('Генерируйте PDF варианты из тестов'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.save, color: Colors.green),
                    title: Text('Сохранение'),
                    subtitle: Text('Все данные сохраняются локально'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.share, color: Colors.green),
                    title: Text('Поделиться'),
                    subtitle: Text('Отправляйте варианты другим'),
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
