import 'package:just_audio/just_audio.dart';

/// A simple audio manager for playing short sound effects. It uses
/// a single AudioPlayer instance from the just_audio package. For
/// multiple simultaneous sounds or very low latency (e.g. piano
/// notes) a SoundPool could be used instead.
class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  /// Plays an audio asset from the bundled assets folder. The path
  /// should begin with `assets/`, for example
  /// `assets/audio/instruments/C.wav`.
  Future<void> play(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      // ignore any errors silently in this demo.
    }
  }
}

/// Global instance of the audio manager.
final audioManager = AudioManager();