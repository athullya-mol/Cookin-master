import 'package:cookin/models/saved_recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Replace with the actual model file for SavedRecipeModel

class SavedRecipesProvider with ChangeNotifier {
  final List<SavedRecipeModel> _savedRecipes = [];

  List<SavedRecipeModel> get savedRecipes => _savedRecipes;

  void addRecipe(SavedRecipeModel recipe) {
    _savedRecipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(String id) {
    _savedRecipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }

  Future<void> loadRecipesForUser(String userId) async {
    _savedRecipes.clear();
    _savedRecipes.addAll(await fetchRecipesForUser(userId));
    notifyListeners();
  }

  Future<List<SavedRecipeModel>> fetchRecipesForUser(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('savedRecipes')
          .get();

      return snapshot.docs.map((doc) {
        return SavedRecipeModel(
          userid: userId,
          id: doc.id,
          name: doc['name'],
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }

  void clearSavedRecipes() {
    _savedRecipes.clear();
    notifyListeners();
    // Optionally clear recipes from the data source if needed
  }
}
