import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SongItem {
  final String title;
  final String? audio;
  const SongItem(this.title, this.audio);

  factory SongItem.fromJson(Map<String, dynamic> j) => SongItem(j['title'] as String, j['audio'] as String?);
}

class SongsRepository {
  Future<List<SongItem>> loadSongs() async {
    try {
      final txt = await rootBundle.loadString('assets/content/songs.json');
      final data = (jsonDecode(txt) as List).cast<Map<String, dynamic>>();
      return data.map(SongItem.fromJson).toList();
    } catch (_) {
      return const [
        SongItem('Twinkle Twinkle Little Star', null),
        SongItem('Jingle Bells', null),
        SongItem('Oh, Susanna', null),
        SongItem('Song Of Joy', null),
      ];
    }
  }
}

final songsRepo = SongsRepository();