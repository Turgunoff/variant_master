import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  color: Colors.deepPurpleAccent,
                  'assets/logo/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'О приложении',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Variant Master — это удобное приложение для учителей и студентов, позволяющее создавать тесты, составлять варианты и сохранять PDF файлы. Все данные сохраняются локально на устройстве.',
                    style: TextStyle(fontSize: 15, height: 1.5),
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
                    'Основные возможности',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _FeatureItem(
                    icon: Icons.add_circle,
                    title: 'Создание тестов',
                    description: 'Добавление тестов по различным предметам',
                  ),
                  _FeatureItem(
                    icon: Icons.shuffle,
                    title: 'Составление вариантов',
                    description: 'Создание вариантов из 30 случайных тестов',
                  ),
                  _FeatureItem(
                    icon: Icons.picture_as_pdf,
                    title: 'Создание PDF',
                    description: 'Сохранение вариантов в формате PDF',
                  ),
                  _FeatureItem(
                    icon: Icons.offline_bolt,
                    title: 'Офлайн работа',
                    description: 'Полностью работает без интернет-соединения',
                  ),
                  _FeatureItem(
                    icon: Icons.security,
                    title: 'Безопасность',
                    description: 'Данные безопасно сохраняются на устройстве',
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
                    'Техническая информация',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Платформа:', value: 'Flutter'),
                  _InfoRow(label: 'Версия:', value: '1.0.0'),
                  _InfoRow(label: 'База данных:', value: 'Hive (Local)'),
                  _InfoRow(label: 'Создание PDF:', value: 'pdf package'),
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
                children: const [
                  Text(
                    'Лицензия',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Приложение бесплатное и с открытым исходным кодом. Вы можете свободно использовать его для личных и образовательных целей.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.15)),
            ),
            child: const Column(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 32),
                SizedBox(height: 8),
                Text(
                  'Спасибо!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Спасибо за использование нашего приложения! Ждем ваших отзывов и предложений.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              if (onTap != null)
                Icon(Icons.copy, size: 16, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
