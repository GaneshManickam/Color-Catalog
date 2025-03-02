import 'package:flutter/material.dart';
import 'models/color_model.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox<Color>('colorsBox');
  runApp(ColorCatalogApp());
}

class ColorCatalogApp extends StatelessWidget {
  const ColorCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Seed color still used for main generation.
          secondary: Color(0xFFFDB7EA), // Light Pink
          surface: Color(0xFFFFDCCC), // Light Peach
          background: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(elevation: 2),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 1,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          secondary: Color(0xFFFDB7EA),
          surface: Color(0xFF222222),
          background: Colors.black,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(elevation: 2),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 1,
          surfaceTintColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
