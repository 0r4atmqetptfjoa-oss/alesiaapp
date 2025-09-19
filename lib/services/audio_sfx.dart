import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioSfx {
  final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.lowLatency);

  Future<void> playAssetPath(String? path) async {
    if (path == null) return;
    try {
      if (kIsWeb) {
        await _player.play(UrlSource(path)); // 'assets/...'
      } else {
        final p = path.startsWith('assets/') ? path.substring(7) : path;
        await _player.play(AssetSource(p));
      }
    } catch (e) {
      // ignore errors in UI
    }
  }
}

final audioSfx = AudioSfx();