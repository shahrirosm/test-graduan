import 'package:flutter/material.dart';
import 'package:graduan_test/features/auth/screens/login_screen.dart';
import 'package:graduan_test/features/posts/screens/home_screen.dart';
import 'package:graduan_test/features/profile/screens/profile_screen.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';

  static const String initialRoute = home;

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => HomeScreen(),
      profile: (context) => ProfileScreen(),
    };
  }
}
