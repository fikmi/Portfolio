import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/knowledge_hub_screen.dart';
import 'screens/upload_screen.dart';
import 'services/app_state.dart';

void main() {
  runApp(const QeCompanionApp());
}

class QeCompanionApp extends StatelessWidget {
  const QeCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..loadSampleData(),
      child: MaterialApp(
        title: 'QE Companion',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/upload': (_) => const UploadScreen(),
          '/dashboard': (_) => const DashboardScreen(),
          '/knowledge': (_) => const KnowledgeHubScreen(),
        },
      ),
    );
  }
}
