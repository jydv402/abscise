import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:abscise/providers/shared_prefs_provider.dart';
import 'package:abscise/routes/app_router.dart';
import 'package:abscise/themes/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  // await dotenv.load(fileName: ".env");

  // Initialize shared preferences
  await AppPreferences.init();

  // Initialize Hive and open the box
  await Hive.initFlutter();
  await Hive.openBox('abscise_bin');

  runApp(const ProviderScope(child: AbsciseApp()));
}

class AbsciseApp extends StatelessWidget {
  const AbsciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Abscise',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
