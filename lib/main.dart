import 'package:flutter/material.dart';
import 'package:graduan_test/core/services/shared_pref_services.dart';
import 'package:graduan_test/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesService();
  await prefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: Routes.getRoutes(),
      initialRoute: Routes.initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
