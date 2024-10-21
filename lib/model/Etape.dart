class Etape {
  int? idEtape;
  int idRecette;
  int numeroEtape;
  String description;

  Etape({
    this.idEtape,
    required this.idRecette,
    required this.numeroEtape,
    required this.description,
  });

  // Convertir l'objet en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'ID_Etape': idEtape,
      'ID_Recette': idRecette,
      'Numero_Etape': numeroEtape,
      'Description': description,
    };
  }

  // Créer un objet Etape à partir d'un Map
  factory Etape.fromMap(Map<String, dynamic> map) {
    return Etape(
      idEtape: map['ID_Etape'],
      idRecette: map['ID_Recette'],
      numeroEtape: map['Numero_Etape'],
      description: map['Description'],
    );
  }
}
