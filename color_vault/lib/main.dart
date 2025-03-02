import 'package:flutter/material.dart';
import 'models/color_model.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // ✅ Replace with Hive.initFlutter()
  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox<Color>('colorsBox'); // ✅ Ensure this matches the box name
  runApp(ColorCatalogApp());
}

class ColorCatalogApp extends StatelessWidget {
  const ColorCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: HomeScreen(),
    );
  }
}
