# Windows Ilovasi Uchun Logo O'zgartirish Qo'llanmasi

Windows ilovasi uchun logo o'zgartirish uchun quyidagi qadamlarni bajarish kerak:

## 1. ICO fayl yaratish

SVG faylini ICO formatiga o'zgartirish uchun quyidagi usullardan birini qo'llashingiz mumkin:

### Online konverterlar:
- [convertio.co](https://convertio.co/svg-ico/)
- [onlineconvertfree.com](https://onlineconvertfree.com/convert/svg-to-ico/)
- [cloudconvert.com](https://cloudconvert.com/svg-to-ico)

### Dasturlar:
- Adobe Photoshop
- GIMP
- Inkscape

## 2. ICO faylini Windows ilovasi resurslariga qo'shish

1. `assets/icons/app_logo.svg` faylini yuqoridagi usullardan biri orqali ICO formatiga o'zgartiring
2. Hosil bo'lgan ICO faylini `windows/runner/resources/app_icon.ico` fayliga almashtiring

## 3. Windows ilovasi konfiguratsiyasini yangilash

Windows ilovasi uchun qo'shimcha konfiguratsiyalarni o'zgartirish uchun quyidagi fayllarni tahrirlashingiz mumkin:

- `windows/runner/Runner.rc` - Windows ilovasi resurslari
- `windows/runner/main.cpp` - Windows ilovasi asosiy fayli
- `windows/CMakeLists.txt` - Windows ilovasi build konfiguratsiyasi

## 4. Ilovani qayta build qilish

Logo o'zgarishlarini ko'rish uchun ilovani qayta build qiling:

```bash
flutter clean
flutter pub get
flutter build windows
```

## Muhim eslatma

Windows ilovasi uchun logo o'zgartirish uchun ICO fayl formati talab qilinadi. SVG formatidagi faylni to'g'ridan-to'g'ri ishlatib bo'lmaydi. Shuning uchun SVG faylini ICO formatiga o'zgartirish kerak.
