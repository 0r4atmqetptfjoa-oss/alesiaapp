import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/animal.dart';

class AnimalsRepository {
  Future<List<AnimalItem>> loadAnimals() async {
    try {
      final txt = await rootBundle.loadString('assets/content/animals.json');
      final data = (jsonDecode(txt) as List).cast<Map<String, dynamic>>();
      return data.map(AnimalItem.fromJson).toList();
    } catch (_) {
      // fallback demo dacă JSON sau assets lipsesc
      return const [
        AnimalItem(name: 'Leu', category: 'salbatice', image: 'assets/images/animals/wild/lion.png', audio: 'assets/audio/animals/lion.mp3'),
        AnimalItem(name: 'Vacă', category: 'ferma', image: 'assets/images/animals/farm/cow.png', audio: 'assets/audio/animals/cow.mp3'),
        AnimalItem(name: 'Delfin', category: 'marine', image: 'assets/images/animals/marine/dolphin.png', audio: 'assets/audio/animals/dolphin.mp3'),
        AnimalItem(name: 'Pui', category: 'ferma', image: 'assets/images/animals/farm/chicken.png', audio: 'assets/audio/animals/chicken.mp3'),
      ];
    }
  }
}

final animalsRepo = AnimalsRepository();