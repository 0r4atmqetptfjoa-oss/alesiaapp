import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StoryItem {
  final String title, body;
  const StoryItem(this.title, this.body);

  factory StoryItem.fromJson(Map<String, dynamic> j) => StoryItem(j['title'] as String, j['body'] as String);
}

class StoriesRepository {
  Future<List<StoryItem>> loadStories() async {
    try {
      final txt = await rootBundle.loadString('assets/content/stories.json');
      final data = (jsonDecode(txt) as List).cast<Map<String, dynamic>>();
      return data.map(StoryItem.fromJson).toList();
    } catch (_) {
      return const [
        StoryItem('Scufița Roșie', 'A fost odată ca niciodată...'),
        StoryItem('Alba ca Zăpada', 'Într-un regat îndepărtat...'),
      ];
    }
  }
}

final storiesRepo = StoriesRepository();