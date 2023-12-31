import 'package:grad/modules/auth/login/login_screen.dart';
import 'package:grad/modules/auth/register/register_screen.dart';
import 'package:grad/modules/home/home_screen.dart';
import 'package:grad/modules/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}

final routes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.register: (context) => const RegisterScreen(),
  AppRoutes.home: (context) => const HomeScreen(),
};
