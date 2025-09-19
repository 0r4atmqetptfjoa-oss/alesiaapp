class AnimalItem {
  final String name;
  final String category; // Animale de fermă / Animale sălbatice / Animale marine
  final String image;    // asset path
  final String? audio;   // optional asset path
  const AnimalItem({required this.name, required this.category, required this.image, this.audio});

  factory AnimalItem.fromJson(Map<String, dynamic> j) =>
      AnimalItem(name: j['name'], category: j['category'], image: j['image'], audio: j['audio']);
}