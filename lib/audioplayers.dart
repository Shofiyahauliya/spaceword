import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  Future<void> playBackgroundMusic(String filePath) async {
    if (!_isPlaying) {
      try {
        await _audioPlayer.setSourceAsset(filePath);
        _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.resume();

        _isPlaying = true;
        log('Musik latar berhasil diputar!');
      } catch (e) {
        log('Gagal memutar musik latar: $e');
      }
    }
  }

  Future<void> stopMusic() async {
    if (_isPlaying) {
      try {
        await _audioPlayer.stop();
        _isPlaying = false;
        log('Musik dihentikan!');
      } catch (e) {
        log('Gagal menghentikan musik: $e');
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
