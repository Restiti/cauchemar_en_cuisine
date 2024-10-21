// lib/providers/ingredient_provider.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../model/Ingredients.dart';

class IngredientProvider with ChangeNotifier {
  List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => _ingredients;

  IngredientProvider() {
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query('Ingredients');

      _ingredients = maps.map((map) => Ingredient.fromMap(map)).toList();

      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des ingrédients: $e");
    }
  }

  // Méthode pour ajouter un ingrédient
  Future<void> addIngredient(Ingredient ingredient) async {
    try {
      final db = await DatabaseHelper().database;
      // Insertion dans la base de données
      await db.insert(
        'Ingredients',
        ingredient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Ajouter l'ingrédient à la liste locale
      _ingredients.add(ingredient);

      // Notifier les widgets écoutant les changements
      notifyListeners();
    } catch (e) {
      print("Erreur lors de l'ajout de l'ingrédient: $e");
    }
  }
}
