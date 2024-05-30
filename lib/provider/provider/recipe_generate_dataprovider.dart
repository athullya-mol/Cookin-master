import 'dart:io';

import 'dart:typed_data';

import 'package:cookin/apis/recipe_ai_generation.dart';
import 'package:cookin/models/image_recipe_generate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecipeGenerateDataProvider extends ChangeNotifier {
  RecipeImageData? image;
  String _recipe = '';
  String get getRecipe => _recipe;
  bool isLoading = false;
  late Uint8List _recipeNameImage = Uint8List(0);

  //by image 
  void setImage(RecipeImageData? image) {
    this.image = image;
    notifyListeners();
  }
  //to get image
  void setRecipeNameImage(Uint8List? image) {
    _recipeNameImage = image!;
    notifyListeners();
  }

  Uint8List? get recipeNameImage => _recipeNameImage;

  Future<void> getGeneratedRecipe(List<String> generatedResponseRecipe,BuildContext context) async {
    print(generatedResponseRecipe);
    String recipeName = '';
    String formattedRecipe = '';
    bool isIngredientsSection = false;
    bool isInstructionsSection = false;

    for (String line in generatedResponseRecipe) {
      if (line.contains('Recipe of')) {
        recipeName = line.substring(' **Recipe of'.length).trim();
      } else if (recipeName.endsWith('**')) {
        recipeName = recipeName.substring(0, recipeName.length - 2).trim();
      } else if (line.contains('**Ingredients:')) {
        formattedRecipe += '\nIngredients\n';
        isIngredientsSection = true;
        isInstructionsSection = false;
      } else if (line.contains('**Instructions:')) {
        formattedRecipe += '\nInstructions\n';
        isInstructionsSection = true;
        isIngredientsSection = false;
      } else if (isIngredientsSection || isInstructionsSection) {
        // Remove *, ** from the beginning and endings of each line
        String formattedLine = line.replaceAll(RegExp(r'^[*]+|[**]+$'), '');
        formattedRecipe += '$formattedLine\n';

        
      }
    }

    _recipe = '\n$recipeName\n\n$formattedRecipe';
    // final imagePrompt = 'Image of $recipeName in jpeg format';
    print("Recipe Name : ${recipeName}");
    final recipeNameImage = await convertTextToImage(recipeName,context);
    setRecipeNameImage(recipeNameImage);
    print(_recipe);
    notifyListeners();
  }

  Future<void> generateRecipeImageRecipe(String imageUrl,BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final generativeAi = GenerativeModel(
          model: "gemini-pro-vision",
          apiKey: "AIzaSyAg6kDvXO5QLhe6GAw9sMI8imczxKlgwHE");
      final imageFile = File(imageUrl);
      final imageBytes = await imageFile.readAsBytes();
      final prompt = TextPart(
          'Generate a recipe to cook with these ingredients with its recipe name by mentioning its name by recipe of, in a doc style.');
      final imagePart = DataPart('image/jpeg', imageBytes);
      final content = [
        Content.multi([imagePart, prompt])
      ];
      final response = await generativeAi.generateContent(content);
      final generatedRecipe = response.text!.split('\n');
      getGeneratedRecipe(generatedRecipe,context);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }

  Future<void> generatedIngredientsRecipe(List<String> ingredients,BuildContext context) async{
   isLoading = true;
    notifyListeners();
    try {
      final generativeAi = GenerativeModel(
          model: "gemini-pro",
          apiKey: "AIzaSyAg6kDvXO5QLhe6GAw9sMI8imczxKlgwHE");
      final textPrompt = 'Recipe with these ${ingredients.join(', ')} ingredients only and its name mentioning recipe name like this " Recipe of recipename "';
      final content = [Content.text(textPrompt)];
      final response = await generativeAi.generateContent(content);
      final generatedRecipe = response.text!.split('\n');

      // const imagePrompt = 'Generate a image ccording to above recipe';
      // final imageContent =[Content.text(imagePrompt)];
      // final imageResponse = await generativeAi.generateContent(imageContent);
      // final generatedImage = imageResponse['image_url'];
    
    getGeneratedRecipe(generatedRecipe,context);
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }

}
