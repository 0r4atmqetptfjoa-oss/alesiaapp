import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:soundpool/soundpool.dart';

/// Global singleton for short SFX playback (low latency).
final AudioManager audioManager = AudioManager._internal();

class AudioManager {
  AudioManager._internal();

  Soundpool? _pool;
  final Map<String, int> _cache = {}; // assetPath -> soundId

  Soundpool get _ensurePool =>
      _pool ??= Soundpool.fromOptions(options: const SoundpoolOptions(streamType: StreamType.music));

  /// Plays an asset WAV/OGG/MP3. Caches the decoded sound in memory for reuse.
  /// Example: await audioManager.play('assets/audio/instruments/C.wav');
  Future<void> play(String assetPath, {double volume = 1.0}) async {
    final pool = _ensurePool;
    int? soundId = _cache[assetPath];
    if (soundId == null) {
      final ByteData data = await rootBundle.load(assetPath);
      soundId = await pool.load(data);
      _cache[assetPath] = soundId;
    }
    final streamId = await pool.play(soundId);
    if (volume != 1.0) {
      try {
        await pool.setVolume(streamId: streamId, volume: volume.clamp(0.0, 1.0));
      } catch (_) {
        // Older platforms may not support setVolume; ignore gracefully.
      }
    }
  }

  /// Frees all cached sounds.
  Future<void> clear() async {
    if (_pool == null) return;
    for (final id in _cache.values) {
      try {
        await _pool!.unload(id);
      } catch (_) {}
    }
    _cache.clear();
  }

  /// Disposes the underlying pool.
  Future<void> dispose() async {
    await clear();
    await _pool?.release();
    _pool = null;
  }
}