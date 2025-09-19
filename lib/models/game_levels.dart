class MemoryLevel {
  final String id;
  final String name;
  final int rows;
  final int cols;
  final List<String> icons;
  const MemoryLevel({required this.id, required this.name, required this.rows, required this.cols, required this.icons});
  factory MemoryLevel.fromJson(Map<String,dynamic> j) => MemoryLevel(
    id: j['id'], name: j['name'], rows: j['rows'], cols: j['cols'],
    icons: (j['icons'] as List).map((e)=> e.toString()).toList(),
  );
}

class AlphabetLevel {
  final String id;
  final List<String> letters;
  final int targets;
  const AlphabetLevel({required this.id, required this.letters, required this.targets});
  factory AlphabetLevel.fromJson(Map<String,dynamic> j) => AlphabetLevel(
    id: j['id'],
    letters: (j['letters'] as List).map((e)=> e.toString()).toList(),
    targets: j['targets'],
  );
}

class NumbersLevel {
  final String id;
  final List<int> range;
  final String goal;
  const NumbersLevel({required this.id, required this.range, required this.goal});
  factory NumbersLevel.fromJson(Map<String,dynamic> j) => NumbersLevel(
    id: j['id'],
    range: (j['range'] as List).map((e)=> int.parse(e.toString())).toList(),
    goal: j['goal'],
  );
}