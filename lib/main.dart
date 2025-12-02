import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ini otomatis dibuat flutterfire
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:spaceword_skorgameplay/page/splash_screen.dart';
import 'package:spaceword_skorgameplay/page/welcome_page.dart';
import 'package:spaceword_skorgameplay/page/google_sign_in.dart';
// import 'package:spaceword/page/home_page.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spaceword_skorgameplay/page/character_customization_page.dart';
import 'package:spaceword_skorgameplay/page/choose_level_page.dart';
import 'package:spaceword_skorgameplay/provider.dart';
// import 'package:spacewordgameapp/audioplayers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await dotenv.load();

  //String sbUrl = dotenv.env['SUPABASE_URL'] ?? '';
  //String sbKey = dotenv.env['SUPABASE_KEY'] ?? '';
  //await Supabase.initialize(url: sbUrl, anonKey: sbKey);

  // final audioService = AudioService();
  // await audioService.playBackgroundMusic('audio/backsound.mp3');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spaceword',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/level',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const StartPage(),
        '/google-login': (context) => const GoogleLoginPage(),
        '/custom': (context) => const CharacterCustomizationPage(),
        '/level': (context) => const GameLevelsPage(),
      },
    );
  }
}