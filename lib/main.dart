import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/router.dart';
import 'core/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
