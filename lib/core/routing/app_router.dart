import 'package:flutter/material.dart';

import '../../features/auth/login/login_page.dart';
import '../../features/auth/register/register_page.dart';
import '../../features/home/home_page.dart';
import '../../features/shell/mobile_shell.dart';

class AppRouter {
  const AppRouter._();

  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';
    switch (routeName) {
      case '/login':
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case '/register':
        return MaterialPageRoute<void>(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
      case '/dashboard':
        return MaterialPageRoute<void>(
          builder: (_) => MobileShell(key: MobileShell.shellKey),
          settings: settings,
        );
      case '/':
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
    }
  }
}
