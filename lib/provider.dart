import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinProvider with ChangeNotifier {
  int _coins = 2000;

  int get coins => _coins;

  CoinProvider() {
    _loadCoins(); // Memuat koin dari penyimpanan saat inisialisasi
  }

  // Menambahkan koin
  void addCoins(int amount) {
    _coins += amount;
    _saveCoins();
    notifyListeners();
  }

  // Mengurangi koin
  void subtractCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      _saveCoins();
      notifyListeners();
    }
  }

  // Membeli skin dengan koin
  bool purchaseSkin(int price) {
    if (_coins >= price) {
      _coins -= price;
      _saveCoins();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Mengonversi skor menjadi koin
  void convertScoreToCoins(int score) {
    _coins += score;
    _saveCoins();
    notifyListeners();
  }

  // Reset jumlah koin ke nilai default
  void resetCoins() {
    _coins = 2000;
    _saveCoins();
    notifyListeners();
  }

  // Sinkronisasi koin dengan skor global
  void syncWithGlobalScore(int globalScore) {
    _coins = globalScore;
    _saveCoins();
    notifyListeners();
  }

  // Simpan koin ke SharedPreferences
  void _saveCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _coins);
  }

  // Muat koin dari SharedPreferences
  Future<void> _loadCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _coins = prefs.getInt('coins') ?? 2000;
    notifyListeners();
  }

  // Method publik untuk load coins secara async
  Future<void> loadCoins() async {
    await _loadCoins();
  }
}

class CharacterProvider with ChangeNotifier {
  String _selectedBody = 'assets/bodies/Alien Biru.png';
  String _selectedClothes = 'assets/clothes/KOSTUM PENCURI.png';
  String _selectedCharacter = 'default';

  String get selectedBody => _selectedBody;
  String get selectedClothes => _selectedClothes;

  // Update karakter dengan body dan baju baru
  void updateCharacter(String body, String clothes) {
    _selectedBody = body;
    _selectedClothes = clothes;
    notifyListeners();
  }

  // Simpan karakter yang dipilih ke SharedPreferences
  Future<void> saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCharacter', _selectedCharacter);
  }

  // Muat karakter yang dipilih dari SharedPreferences
  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCharacter = prefs.getString('selectedCharacter') ?? 'default';
    notifyListeners();
  }
}
