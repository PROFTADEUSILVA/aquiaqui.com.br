import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/tag_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/generate_tag_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AquiApp());
}

class AquiApp extends StatelessWidget {
  const AquiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagService(),
      child: MaterialApp(
        title: 'Aqui, AQUI!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9E75)),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/home':   (_) => const HomeScreen(),
          '/gerar':  (_) => const GenerateTagScreen(),
        },
      ),
    );
  }
}