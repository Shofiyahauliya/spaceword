import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceword_skorgameplay/provider.dart';

class CharacterCustomizationPage extends StatefulWidget {
  const CharacterCustomizationPage({super.key});

  @override
  _CharacterCustomizationPageState createState() => _CharacterCustomizationPageState();
}

class _CharacterCustomizationPageState extends State<CharacterCustomizationPage> {
  String selectedBody = 'assets/bodies/Alien Biru.png';
  String selectedClothes = 'assets/clothes/KOSTUM PENCURI.png';
  int playerCoins = 0;

  final List<String> bodyAssets = [
    'assets/bodies/Alien Biru.png',
    'assets/bodies/Alien Hijau.png',
    'assets/bodies/Alien Pink.png',
    'assets/bodies/Alien Ungu.png',
    'assets/bodies/Alien Kuning.png',
  ];

  final List<int> bodyPrices = [300, 400, 500, 600, 700];

  final List<String> clothesAssets = [
    'assets/clothes/KOSTUM PENCURI.png',
    'assets/clothes/Kostum Iblis Revisi.png',
    'assets/clothes/Kostum Koki Revisi lagi.png',
    'assets/clothes/Kostum Raja.png',
    'assets/clothes/Kostum Domba.png',
    'assets/clothes/Kostum Rubah.png',
    'assets/clothes/Kostum Sapi.png',
    'assets/clothes/Kostum Santa.png',
    'assets/clothes/Kostum Superhero.png',
  ];

  final List<int> clothesPrices = [200, 300, 400, 500, 600, 700, 800, 900, 1000];

  List<String> purchasedBodies = [];
  List<String> purchasedClothes = [];

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadCharacterPreferences();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    setState(() {
      _isLoggedIn = isLoggedIn;
    });

    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  Future<void> _loadCharacterPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedBody = prefs.getString('selectedBody') ?? bodyAssets[0];
      selectedClothes = prefs.getString('selectedClothes') ?? clothesAssets[0];
      purchasedBodies = prefs.getStringList('purchasedBodies') ?? [bodyAssets[0]];
      purchasedClothes = prefs.getStringList('purchasedClothes') ?? [clothesAssets[0]];
    });
  }

  Future<void> _saveCharacterPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBody', selectedBody);
    await prefs.setString('selectedClothes', selectedClothes);
    await prefs.setStringList('purchasedBodies', purchasedBodies);
    await prefs.setStringList('purchasedClothes', purchasedClothes);
    await prefs.setInt('playerCoins', playerCoins);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    coinProvider.resetCoins();

    Navigator.pushReplacementNamed(context, '/auth');
  }

  void selectItem(String item, String itemType) {
    setState(() {
      if (itemType == 'clothes') {
        selectedClothes = item;
      } else if (itemType == 'body') {
        selectedBody = item;
      }
    });
    _saveCharacterPreferences();

    final characterProvider = Provider.of<CharacterProvider>(context, listen: false);
    characterProvider.updateCharacter(selectedBody, selectedClothes);
  }

  void buyItem(int price, String item, String itemType) {
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);

    if (coinProvider.purchaseSkin(price)) {
      setState(() {
        if (itemType == 'clothes') {
          purchasedClothes.add(item);
        } else if (itemType == 'body') {
          purchasedBodies.add(item);
        }

        _saveCharacterPreferences();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins!')),
      );
    }
  }

  void showConfirmationDialog(BuildContext context, String itemType, String item, int price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: Text('Do you want to buy this $itemType for $price coins?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                buyItem(price, item, itemType);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC700), size: 30),
          onPressed: () => Navigator.pop(context),
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
                      style: const TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    IconButton(
                      icon: const Icon(Icons.monetization_on, color: Color(0xFFFFC700), size: 30),
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: logout,
            child: const Text('Sign out'),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(selectedBody, height: 220),
                  Image.asset(selectedClothes, height: 220),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Clothes
          _buildCategorySection('Clothes', clothesAssets, clothesPrices, purchasedClothes, 'clothes'),

          const SizedBox(height: 16),

          // Skins
          _buildCategorySection('Skin', bodyAssets, bodyPrices, purchasedBodies, 'body'),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<String> items, List<int> prices,
      List<String> purchasedList, String itemType) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final isPurchased = purchasedList.contains(items[index]);
                return GestureDetector(
                  onTap: () {
                    if (isPurchased) {
                      selectItem(items[index], itemType);
                    } else {
                      showConfirmationDialog(context, itemType, items[index], prices[index]);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                    decoration: BoxDecoration(
                      color: isPurchased ? Colors.grey : const Color(0xFFBB84F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 90,
                            child: Image.asset(items[index], fit: BoxFit.contain),
                          ),
                          if (!isPurchased)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('${prices[index]} coins', style: const TextStyle(fontSize: 16)),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
