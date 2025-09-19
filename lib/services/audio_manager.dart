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
    // Adjust volume if needed (some platforms may ignore this on web).
    if (volume != 1.0) {
      try {
        await pool.setVolume(streamId: streamId, volume: volume.clamp(0.0, 1.0));
      } catch (_) {}
    }
  }

  /// Frees all cached sounds and releases the pool.
  Future<void> clear() async {
    if (_pool == null) return;
    _cache.clear();
    try {
      await _pool!.release(); // Releases the whole pool (Soundpool 2.4.x API)
    } catch (_) {}
    _pool = null;
  }

  Future<void> dispose() async => clear();
}