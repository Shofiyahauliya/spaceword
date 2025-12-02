import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'package:spaceword_skorgameplay/constants/styles.dart';
import 'package:spaceword_skorgameplay/page/character_customization_page.dart';
import 'package:spaceword_skorgameplay/page/level_page.dart';
import 'package:spaceword_skorgameplay/provider.dart';
import 'package:spaceword_skorgameplay/settings.dart';

class GameLevelsPage extends StatefulWidget {
  const GameLevelsPage({super.key});

  @override
  State<GameLevelsPage> createState() => _GameLevelsPageState();
}

class _GameLevelsPageState extends State<GameLevelsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coinProvider = Provider.of<CoinProvider>(context, listen: false);
      coinProvider.loadCoins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/image/Tombol Back.png", width: 50, height: 50),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Consumer<CoinProvider>(
              builder: (context, coinProvider, child) {
                return Row(
                  children: [
                    Text(
                      '${coinProvider.coins}',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    IconButton(
                      icon: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset("assets/image/Icon Coin.png"),
                      ),
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/Background Difficulty.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/image/Judul Spaceword (Roket).png', width: 220),
              const SizedBox(height: 5),

              // Tombol level
              Column(
                children: [
                  _buildLevelButton('EASY', Colors.green, const EasyLevel()),
                  const SizedBox(height: 20),
                  _buildLevelButton(
                      'MEDIUM', Colors.yellow, const MediumLevel()),
                  const SizedBox(height: 20),
                  _buildLevelButton('HARD', Colors.red, const HardLevel()),
                ],
              ),

              const SizedBox(height: 40),

              // Ikon navigasi bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircleIcon("assets/image/Tombol Custom.png", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CharacterCustomizationPage()),
                    );
                  }, size: 110),
                  _buildCircleIcon("assets/image/Tombol Home.png", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsModal()),
                    );
                  }, size: 115),
                  _buildCircleIcon("assets/image/Pengaturan.png",
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsModal()),
                    );
                  }, size: 110),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(String label, Color color, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black45)],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'FontdinerSwanky',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(String path, VoidCallback onTap, {double size = 90}) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}