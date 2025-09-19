class AnimalItem {
  final String name;
  final String category;
  final String image;
  const AnimalItem({required this.name, required this.category, required this.image});

  factory AnimalItem.fromJson(Map<String, dynamic> j) =>
      AnimalItem(name: j['name'], category: j['category'], image: j['image']);
}