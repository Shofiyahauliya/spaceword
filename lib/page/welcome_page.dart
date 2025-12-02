// --- import
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------------- START PAGE
class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const SettingsModal(),
    );
  }

  void _navigateWithScale(BuildContext context, Widget page) {
    Navigator.of(context).push(_createScaleFullPageRoute(page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/background/teksspaceword.png',
                  width: 600,
                  height: 300,
                ),
                const SizedBox(height: 40),
                GradientButton(
                  text: 'MULAI',
                  onPressed: () {
                    _navigateWithScale(context, const CharacterSelectionPage());
                  },
                ),
                const SizedBox(height: 20),
                GradientButton(
                  text: 'PENGATURAN',
                  fontSize: 20,
                  onPressed: () => _showSettingsDialog(context),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------- CHARACTER SELECTION
class CharacterSelectionPage extends StatefulWidget {
  const CharacterSelectionPage({Key? key}) : super(key: key);

  @override
  State<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  String? selectedCharacterName;

  void selectCharacter(String name) {
    setState(() {
      selectedCharacterName = name;
    });
  }

  void _navigateWithScale(BuildContext context, Widget page) {
    Navigator.of(context).push(_createScaleFullPageRoute(page));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/bg select char.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            const SizedBox(height: 80), // Header padding atas
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFAA55FF),
                    Color(0xFF7F18C8),
                  ], // sama dengan tombol "LANJUT"
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Text(
                    'PILIH',
                    style: TextStyle(
                      fontFamily: 'FontdinerSwanky',
                      fontSize: 40,
                      color: Color(0xFFFFF50B),
                      height: 2.0,
                    ),
                  ),
                  Text(
                    'KARAKTER',
                    style: TextStyle(
                      fontFamily: 'FontdinerSwanky',
                      fontSize: 40,
                      color: Color(0xFFFFF50B),
                      height: 1.5, // Ubah height agar tulisan lebih dekat
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0), // Jarak setelah "PILIH KARAKTER"
            SizedBox(
              height: screenHeight * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CharacterOption(
                    imagePath: 'assets/bodies/Karakter Astro.png',
                    name: 'Astro',
                    nameColor: Colors.cyan,
                    isSelected: selectedCharacterName == 'Astro',
                    onSelect: selectCharacter,
                  ),
                  CharacterOption(
                    imagePath: 'assets/bodies/Karakter Vega.png',
                    name: 'Vega',
                    nameColor: const ui.Color.fromARGB(255, 208, 51, 203),
                    isSelected: selectedCharacterName == 'Vega',
                    onSelect: selectCharacter,
                  ),
                  CharacterOption(
                    imagePath: 'assets/bodies/Karakter Nova.png',
                    name: 'Nova',
                    nameColor: const ui.Color.fromARGB(255, 64, 164, 116),
                    isSelected: selectedCharacterName == 'Nova',
                    onSelect: selectCharacter,
                  ),
                ],
              ),
            ),
            const Spacer(),
            GradientButton(
              text: 'LANJUT',
              onPressed: () {
                // Navigasi lanjut
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

//karakter
class CharacterOption extends StatelessWidget {
  final String imagePath;
  final String name;
  final Color nameColor;
  final bool isSelected;
  final Function(String) onSelect;

  const CharacterOption({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.nameColor,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(name),
        child: AnimatedScale(
          scale: isSelected ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border:
                  isSelected
                      ? Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 4,
                      )
                      : null,
              boxShadow: [
                BoxShadow(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(0.7)
                          : Colors.transparent,
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    // Outline putih
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'FontdinerSwanky',
                        fontSize: 24,
                        foreground:
                            Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.white,
                      ),
                    ),
                    // Isi teks berwarna sesuai karakter
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'FontdinerSwanky',
                        fontSize: 24,
                        color: nameColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: screenHeight * 0.23,
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------- GRADIENT BUTTON
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontSize;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFAA55FF), Color(0xFF7F18C8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            width: 160,
            height: 55,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'FontdinerSwanky',
                fontSize: fontSize ?? 25,
                color: const Color(0xFFFFF50B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------- SETTINGS MODAL
class SettingsModal extends StatefulWidget {
  const SettingsModal({Key? key}) : super(key: key);

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal>
    with SingleTickerProviderStateMixin {
  double _musicVolume = 0.5;
  double _soundVolume = 0.5;
  late Future<ui.Image> _imageFuture;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage('assets/background/sound.png');
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  Future<ui.Image> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    final list = data.buffer.asUint8List();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, (img) => completer.complete(img));
    return completer.future;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget buildSlider(
    IconData icon,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.yellow, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: FutureBuilder<ui.Image>(
            future: _imageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    activeTrackColor: const Color(0xFFB19CD9),
                    inactiveTrackColor: Colors.grey,
                    thumbShape: CustomSliderThumbImage(snapshot.data!),
                    overlayColor: const Color(0xFFB19CD9),
                  ),
                  child: Slider(
                    value: value,
                    min: 0.0,
                    max: 1.0,
                    onChanged: onChanged,
                  ),
                );
              } else {
                return Slider(
                  value: value,
                  min: 0.0,
                  max: 1.0,
                  onChanged: onChanged,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFBD7BFF), Color(0xFF7F18C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "PENGATURAN",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'FontdinerSwanky',
                      color: Color(0xFFFFF50B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildSlider(
                    Icons.music_note,
                    _musicVolume,
                    (val) => setState(() => _musicVolume = val),
                  ),
                  buildSlider(
                    Icons.volume_up,
                    _soundVolume,
                    (val) => setState(() => _soundVolume = val),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => SystemNavigator.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 200, 50, 39),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "KELUAR",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'FontdinerSwanky',
                          color: Color(0xFFFFF50B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: GestureDetector(
                onTap:
                    () => _animationController.reverse().then((_) {
                      if (mounted) Navigator.of(context).pop();
                    }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDBB3F8),
                      width: 2,
                    ),
                    color: const Color(0xFFC465ED),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.yellow,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------- SLIDER THUMB
class CustomSliderThumbImage extends SliderComponentShape {
  final ui.Image image;
  final double thumbSize;
  CustomSliderThumbImage(this.image, {this.thumbSize = 50});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(thumbSize, thumbSize);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Rect imageRect = Rect.fromCenter(
      center: center,
      width: thumbSize,
      height: thumbSize,
    );
    paintImage(
      canvas: canvas,
      rect: imageRect,
      image: image,
      fit: BoxFit.contain,
    );
  }
}

// ----------------------------- FULL PAGE SCALE TRANSITION
Route _createScaleFullPageRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
      return ScaleTransition(
        scale: scale,
        alignment: Alignment.center,
        child: child,
      );
    },
  );
}
