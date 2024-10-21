// lib/providers/etape_provider.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/Etape.dart';

class EtapeProvider with ChangeNotifier {
  List<Etape> _etapes = [];

  List<Etape> get etapes => _etapes;

  EtapeProvider(int idRecette) {
    fetchEtapes(idRecette);
  }

  Future<void> fetchEtapes(int idRecette) async {
    try {
      final db = await DatabaseHelper().database;

      final List<Map<String, dynamic>> maps = await db.query(
        'Etapes',
        where: 'ID_Recette = ?',
        whereArgs: [idRecette],
        orderBy: 'Numero_Etape ASC',
      );

      _etapes = maps.map((map) => Etape.fromMap(map)).toList();

      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des étapes: $e");
    }
  }
}
