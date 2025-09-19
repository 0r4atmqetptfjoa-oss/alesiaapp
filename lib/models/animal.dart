class AnimalItem {
  final String name;
  final String category; // 'ferma', 'salbatice', 'marine'
  final String image;    // assets path
  final String? audio;   // assets path sau null
  const AnimalItem({required this.name, required this.category, required this.image, this.audio});

  factory AnimalItem.fromJson(Map<String, dynamic> j) => AnimalItem(
    name: j['name'] as String,
    category: j['category'] as String,
    image: j['image'] as String,
    audio: j['audio'] as String?,
  );
}