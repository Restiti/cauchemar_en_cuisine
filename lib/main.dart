// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Page/RecetteDetailPage.dart';
import 'Provider/EtapeProvider.dart';
import 'Provider/IngredientProvider.dart';
import 'Provider/RecetteProvider.dart';
import 'database/database_helper.dart';
import 'model/Recette.dart'; // Assure-toi que DatabaseHelper est initialisé

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser la base de données
  await DatabaseHelper().database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(create: (_) => RecetteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Planificateur de Repas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Accéder aux providers
    final ingredientProvider = Provider.of<IngredientProvider>(context);
    final recetteProvider = Provider.of<RecetteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Ingrédients
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ingrédients',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ingredientProvider.ingredients.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ingredientProvider.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredientProvider.ingredients[index];
                return ListTile(
                  title: Text(ingredient.nomIngredient),
                  subtitle: Text(
                      'Quantité: ${ingredient.quantite} ${ingredient.unite}'),
                );
              },
            ),
            Divider(),

            // Section Recettes
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recettes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            recetteProvider.recettes.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recetteProvider.recettes.length,
              itemBuilder: (context, index) {
                final recette = recetteProvider.recettes[index];
                return ListTile(
                  title: Text(recette.nomRecette),
                  subtitle: Text(
                      'Temps de préparation: ${recette.tempsPreparation} minutes'),
                  onTap: () {
                    // Naviguer vers une page de détails avec les étapes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecetteDetailPage(recette: recette),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

