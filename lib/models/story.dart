class Story {
  final String id;
  final String title;
  final String source;
  final String language;
  final List<String> paragraphs;
  const Story({required this.id, required this.title, required this.source, required this.language, required this.paragraphs});

  factory Story.fromJson(Map<String, dynamic> j) => Story(
    id: j['id'],
    title: j['title'],
    source: j['source'] ?? '',
    language: j['language'] ?? 'ro',
    paragraphs: (j['paragraphs'] as List).map((e)=> e.toString()).toList(),
  );
}