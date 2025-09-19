import 'package:just_audio/just_audio.dart';

/// Background music player for longer tracks with pause/resume/loop.
class BackgroundMusicManager {
  final AudioPlayer _player = AudioPlayer();

  Future<void> loadAsset(String assetPath, {bool loop = true}) async {
    await _player.setAsset(assetPath);
    if (loop) {
      await _player.setLoopMode(LoopMode.one);
    } else {
      await _player.setLoopMode(LoopMode.off);
    }
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> setVolume(double v) => _player.setVolume(v);
  Future<void> dispose() => _player.dispose();
}