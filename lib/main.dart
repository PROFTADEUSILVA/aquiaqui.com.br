import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/tag_service.dart';
import 'screens/home_screen.dart';
import 'screens/generate_tag_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AquiApp());
}

class AquiApp extends StatelessWidget {
  const AquiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagService(),
      child: MaterialApp(
        title: 'Aqui',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9E75)),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/home': (_) => const HomeScreen(),
          '/gerar': (_) => const GenerateTagScreen(),
        },
      ),
    );
  }
}
