// lib/providers/recette_provider.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/Recette.dart';

class RecetteProvider with ChangeNotifier {
  List<Recette> _recettes = [];

  List<Recette> get recettes => _recettes;

  RecetteProvider() {
    fetchRecettes();
  }

  Future<void> fetchRecettes() async {
    try {
      final db = await DatabaseHelper().database;

      // Récupérer les recettes
      final List<Map<String, dynamic>> maps = await db.query('Recette');
      _recettes = maps.map((map) => Recette.fromMap(map)).toList();
      print("Données brutes Recettes récupérées : $maps");

      notifyListeners();

      // Récupérer les ingrédients pour test
      final List<Map<String, dynamic>> mapsIngredient = await db.query('Ingredients');
      print("Données brutes Ingrédients récupérées : $mapsIngredient");

    } catch (e) {
      print("Erreur lors de la récupération des recettes: $e");
    }
  }
}
