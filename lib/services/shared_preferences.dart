// globals.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookin/models/saved_recipes_model.dart';

Future<List<SavedRecipeModel>> getSavedRecipesFromPrefs(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final savedRecipesJson = prefs.getString('savedRecipes_$userId');
  
  if (savedRecipesJson != null) {
    final decodedList = json.decode(savedRecipesJson) as List<dynamic>;
    return decodedList.map((item) => SavedRecipeModel.fromJson(item)).toList();
  }
  
  return [];
}

Future<void> saveRecipesToPrefs(List<SavedRecipeModel> savedRecipes, String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final savedRecipesJson = jsonEncode(savedRecipes.map((recipe) => recipe.toJson()).toList());
  await prefs.setString('savedRecipes_$userId', savedRecipesJson);
}

// Future<List<SavedRecipeModel>> loadSavedRecipes(String userId) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? savedRecipesJson = prefs.getString('savedRecipes_$userId');
//   if (savedRecipesJson != null) {
//     List<dynamic> decodedList = json.decode(savedRecipesJson);
//     return decodedList.map((item) => SavedRecipeModel.fromJson(item)).toList();
//   }
//   return [];

// }

Future<void> clearSavedRecipes(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('savedRecipes_$userId'); // Remove recipes based on userId
}