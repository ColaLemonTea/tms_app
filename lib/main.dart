import 'package:flutter/material.dart';
import 'presentation/pages/auth_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMS 企业版',
      theme: ThemeData(
        primaryColor: const Color(0xFF2B7BFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B7BFF),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.auth,
      routes: {
        AppRoutes.auth: (context) => const AuthPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
