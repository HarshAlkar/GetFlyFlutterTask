import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/project_list_screen.dart';
import 'screens/dpr_form_screen.dart';
import 'providers/dpr_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DprProvider()),
      ],
      child: MaterialApp(
        title: 'Construction Field Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          ProjectListScreen.routeName: (_) => const ProjectListScreen(),
          DprFormScreen.routeName: (ctx) => const DprFormScreen(),
        },
      ),
    );
  }
}
