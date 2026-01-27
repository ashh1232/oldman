# Build Flavors - Quick Reference

## 🚀 Run Commands

### Development

```powershell
flutter run --flavor dev -t lib/main_dev.dart
```

### Staging

```powershell
flutter run --flavor staging -t lib/main_staging.dart
```

### Production

```powershell
flutter run --flavor prod -t lib/main.dart
```

## 📦 Build Commands

### Dev Debug APK

```powershell
flutter build apk --flavor dev -t lib/main_dev.dart --debug
```

### Staging Release APK

```powershell
flutter build apk --flavor staging -t lib/main_staging.dart --release
```

### Production Release APK

```powershell
flutter build apk --flavor prod -t lib/main.dart --release
```

## 💻 Using VS Code

تم إنشاء ملف `.vscode/launch.json` تلقائياً. لتشغيل التطبيق من VS Code:

1. اضغط `F5` أو اذهب إلى **Run and Debug** (Ctrl+Shift+D)
2. اختر البيئة المطلوبة من القائمة المنسدلة:
   - **Development** - لبيئة التطوير
   - **Staging** - لبيئة التجريب
   - **Production** - للإنتاج
3. اضغط على زر التشغيل الأخضر

> [!IMPORTANT]
> **لا تستخدم F5 مباشرة بدون اختيار البيئة!** يجب أن تختار البيئة أولاً من القائمة المنسدلة في لوحة Debug.

## 📝 Update Server URLs

Edit: `lib/core/config/app_environment.dart`

```dart
// Development - Current
serverUrl: 'http://192.168.43.19/doc/docana-back'

// Staging - Update this when ready
serverUrl: 'https://staging-api.yourdomain.com'

// Production - Update this when ready
serverUrl: 'https://api.yourdomain.com'
```

## 🔧 Troubleshooting

### Clean build if issues occur

```powershell
flutter clean
flutter pub get
```

### Check current environment at runtime

The app logs environment info at startup:

```
🌍 Environment initialized: Development
📡 Server URL: http://192.168.43.19/doc/docana-back
```

### VS Code shows "Gradle build failed"

This usually means you didn't select the correct launch configuration:

1. Go to Run and Debug panel (Ctrl+Shift+D)
2. Select "Development" from the dropdown at the top
3. Press F5 or click the green play button
