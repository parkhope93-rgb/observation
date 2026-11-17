import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'navigation/main_shell.dart';

class ObservatoryApp extends StatelessWidget {
  const ObservatoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Observatory',
      theme: appTheme,
      home: const MainShell(),
    );
  }
}

class SetupApp extends StatelessWidget {
  const SetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Supabase 설정이 필요해.\n'
              'README의 실행 방법을 따라 '
              'SUPABASE_URL과 SUPABASE_ANON_KEY를 전달해 줘.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}