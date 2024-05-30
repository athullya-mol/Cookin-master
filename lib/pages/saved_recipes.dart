import 'package:cookin/apis/recipe_reps.dart';
import 'package:cookin/models/saved_recipes_model.dart';
import 'package:cookin/pages/recipe_page.dart';
import 'package:cookin/services/shared_preferences.dart';
import 'package:cookin/utils/colors.dart';
import 'package:cookin/utils/navigatio_bar.dart';
import 'package:cookin/widget/widget.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  final String userId; // Add user ID as a parameter
  const SavedPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<SavedRecipeModel> savedRecipesData = [];

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    savedRecipesData = await getSavedRecipesFromPrefs(widget.userId);
    setState(() {}); // Update the UI after loading recipes
  }

  Future<void> _saveRecipes() async {
    await saveRecipesToPrefs(savedRecipesData, widget.userId);
  }

  Future<void> _clearSavedRecipes() async {
    await clearSavedRecipes(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Saved Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: AppColors.textColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottonNavBar()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Clear All Saved Recipes?',
                    style: TextStyle(
                      color: AppColors.textColor,
                    ),
                  ),
                  content: const Text(
                    'Are you sure you want to clear all saved recipes?',
                    style: TextStyle(
                      color: AppColors.textColor,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          savedRecipesData.clear();
                          _clearSavedRecipes(); // Clear saved recipes from local storage
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete, color: AppColors.textColor),
          ),
        ],
      ),
      body: savedRecipesData.isEmpty
          ? const Center(
              child: Text(
                'No saved recipes',
                style: TextStyle(
                  color: AppColors.textColor,
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: savedRecipesData.map((recipe) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Dismissible(
                          key: Key(recipe.id), // Unique key for each recipe
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              savedRecipesData.remove(recipe);
                              _saveRecipes(); // Update local storage
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                '${recipe.name} deleted!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.5),
                            ));
                          },
                          background: Container(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipePage(
                                    mealId: int.parse(recipe.id),
                                    repository: RecipesRepository(),
                                  ),
                                ),
                              );
                            },
                            child: FoodCard(
                              title: recipe.name,
                              thumbnailUrl: recipe.imageUrl,
                              isLoading: false,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
