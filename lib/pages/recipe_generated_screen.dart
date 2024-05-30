import 'dart:io';
import 'package:cookin/models/image_recipe_generate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipeGeneratedDetailScreen extends StatelessWidget {
  final RecipeImageData? image;
  final String recipe;
  final Uint8List recipeNameImage;
  const RecipeGeneratedDetailScreen({super.key, required this.recipe, this.image, required this.recipeNameImage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Stack(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child:( image != null || recipeNameImage.isNotEmpty)
                      ? Image.file(File(image!.imageRecipe!),
                      fit: BoxFit.cover,)
                      : Image.memory(recipeNameImage)
                ),
                Positioned(
                    top: 20,
                    left: 18,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        highlightColor: Colors.black,
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Colors.deepPurple.withOpacity(0.8)),
                            padding: const WidgetStatePropertyAll(
                                EdgeInsets.only(left: 8))),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        )))
              ]),
              Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    recipe,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  
}
