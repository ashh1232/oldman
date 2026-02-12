import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maneger/controller/auth_controller/storage_service.dart';
import 'package:maneger/core/config/app_environment.dart';
import 'package:maneger/core/config/environment_manager.dart';
import 'package:maneger/service/my_theme.dart';
import 'package:maneger/service/theme_service.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize storage
  await Get.putAsync(() => StorageService().init());

  // Initialize PRODUCTION environment
  EnvironmentManager().initialize(AppEnvironment.production);

  // Optional: Global error reporting can be added here
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Docana Manager',
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode: ThemeService().theme, // Loads saved theme  from GetStorage

      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,

      // Localization
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),

      debugShowCheckedModeBanner: false,
    );
  }
}
