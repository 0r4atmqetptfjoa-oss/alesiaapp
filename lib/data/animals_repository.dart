import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/animal.dart';

class AnimalsRepository {
  Future<List<AnimalItem>> loadAnimals() async {
    try {
      final raw = await rootBundle.loadString('assets/content/animals.json');
      final js = jsonDecode(raw) as Map<String, dynamic>;
      return (js['animals'] as List).map((e) => AnimalItem.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}

final animalsRepo = AnimalsRepository();