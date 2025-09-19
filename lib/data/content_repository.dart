import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/song.dart';
import '../models/story.dart';
import '../models/game_levels.dart';

class ContentRepository {
  Future<List<Song>> loadSongs() async {
    try {
      final raw = await rootBundle.loadString('assets/content/songs.json');
      final js = jsonDecode(raw) as Map<String, dynamic>;
      return (js['songs'] as List).map((e)=> Song.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Story>> loadStories() async {
    try {
      final raw = await rootBundle.loadString('assets/content/stories.json');
      final js = jsonDecode(raw) as Map<String, dynamic>;
      return (js['stories'] as List).map((e)=> Story.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>> loadGamesRaw() async {
    try {
      final raw = await rootBundle.loadString('assets/content/games.json');
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}

final contentRepo = ContentRepository();