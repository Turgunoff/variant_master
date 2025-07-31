# Variant Master

Variant Master — это приложение для создания офлайн тестов и вариантов для учителей и студентов. С помощью приложения вы можете добавлять тесты, составлять варианты из 30 случайных тестов и сохранять их в формате PDF. Все данные сохраняются локально на устройстве, интернет не требуется.

## 📱 Основные возможности

- Работает без учетной записи пользователя и офлайн
- Добавление и редактирование тестов
- Разделение тестов по предметам
- Создание вариантов из 30 случайных тестов
- Сохранение и отправка вариантов в формате PDF
- Список сохраненных вариантов
- Управление темным/светлым режимом и размером шрифта
- Удобная навигация на основе drawer меню
- Все тексты на русском языке

## 🚀 Начало работы

### 1. Клонируйте репозиторий

```sh
git clone https://github.com/yourusername/variant_master.git
cd variant_master
```

### 2. Установите пакеты

```sh
flutter pub get
```

### 3. Сгенерируйте Hive адаптеры

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Сборка для Android/iOS

```sh
flutter run
```

### 5. Автоматическая загрузка демо тестов

При первом запуске приложения для каждого предмета автоматически загружается по 50 демо тестов.

## ⚙️ Техническая информация

- **Платформа:** Flutter
- **Локальная база:** Hive
- **PDF:** pdf, printing package
- **Иконки:** iconsax
- **Управление состоянием:** setState (для простого приложения)

## 📂 Структура папок

```
lib/
  main.dart
  models/
    test_model.dart
    variant_model.dart
  pages/
    home_page.dart
    add_test_page.dart
    create_variant_page.dart
    saved_variants_page.dart
    settings_page.dart
    about_page.dart
```

## 📝 Использование

- Выберите нужный раздел из drawer меню
- Добавьте новый тест и укажите предмет
- В разделе создания вариантов выберите предмет и создайте PDF вариант из 30 случайных тестов
- Просматривайте сохраненные варианты и скачивайте или отправляйте PDF файлы

## 🛠️ Для разработчиков

- Код чистый и прокомментированный
- Отдельный widget для каждой страницы
- Модели и локальное хранилище через Hive
- Для демо тестов есть функция `insertDemoTests()` в `main.dart`

## 📸 Скриншоты

<table>
  <tr>
    <td align="center"><img src="screenshots/home.png" alt="Главная страница" width="350" /><br>Главная страница</td>
    <td align="center"><img src="screenshots/add_test.png" alt="Добавить новый тест" width="350" /><br>Добавить новый тест</td>
    <td align="center"><img src="screenshots/tests.png" alt="Список тестов" width="350" /><br>Список тестов</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/create_variant.png" alt="Создание варианта" width="350" /><br>Создание варианта</td>
    <td align="center"><img src="screenshots/save_variant.png" alt="Сохранение варианта" width="350" /><br>Сохранение варианта</td>
    <td align="center"><img src="screenshots/about.png" alt="О приложении" width="350" /><br>О приложении</td>
  </tr>
</table>

## 👨‍💻 Автор и участники

- Eldor Turgunov

## 📄 Лицензия

MIT
