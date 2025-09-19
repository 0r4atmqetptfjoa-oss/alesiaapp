import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioSfx {
  final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.lowLatency);

  Future<void> playAssetPath(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      if (kIsWeb) {
        await _player.play(UrlSource(path)); // pe web, folosim UrlSource('assets/...')
      } else {
        final p = path.startsWith('assets/') ? path.substring(7) : path;
        await _player.play(AssetSource(p));
      }
    } catch (_) {
      // soft-fail în UI
    }
  }
}

final audioSfx = AudioSfx();