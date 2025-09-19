class Song {
  final String id;
  final String title;
  final String language;
  final List<String> lyrics;
  final List<String> notes;
  const Song({required this.id, required this.title, required this.language, required this.lyrics, required this.notes});

  factory Song.fromJson(Map<String, dynamic> j) => Song(
    id: j['id'],
    title: j['title'],
    language: j['language'] ?? 'ro',
    lyrics: (j['lyrics'] as List).map((e)=> e.toString()).toList(),
    notes: (j['notes'] as List).map((e)=> e.toString()).toList(),
  );
}