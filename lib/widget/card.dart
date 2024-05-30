import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cookin/apis/recipe_reps.dart';
import 'package:cookin/models/category_model.dart';
import 'package:cookin/models/item_model.dart';
import 'package:cookin/models/saved_recipes_model.dart';
import 'package:cookin/pages/recipe_page.dart';
import 'package:cookin/services/shared_preferences.dart';
import 'package:cookin/utils/colors.dart';

import 'package:cookin/widget/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:uuid/uuid.dart';

import '../apis/mealdb_api.dart';

List<SavedRecipeModel> savedRecipesData = [];

class OverflowCard extends StatelessWidget {
  OverflowCard({
    required RecipesRepository repository,
    super.key,
    this.title = '',
    this.thumbnailUrl = '',
  }) : _repository = repository;

  final String title;
  final String rating = randomRating();
  final String cookTime = randomCookTime();
  final String thumbnailUrl;
  final RecipesRepository _repository;

  @override
  Widget build(BuildContext context) {
    const double circleRadius = 150.0;
    const double circleBorderWidth = 8.0;
    final size = MediaQuery.of(context).size;

    return FutureBuilder<ItemModel>(
        future: _repository.randomMeals(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Meals> index = snapshot.data!.meals;
            return GestureDetector(
              onTap: () {
                int mealId = int.parse(index[0].idMeal);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipePage(
                              mealId: mealId,
                              repository: RecipesRepository(),
                            )));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: circleRadius / 2.0),
                      child: Container(
                        height: 200,
                        width: 180,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: const Color.fromRGBO(217, 217, 217, 0.5),
                        ),

                        child: Column(
                          children: [
                            const SizedBox(height: 70),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 38.5,
                                    child: AutoSizeText(
                                      index[0].strMeal,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        height: 1.2,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.1.h),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const MyText(
                                            text: 'Time',
                                            color: Colors.black38,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          MyText(
                                            text: cookTime,
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      IconButton.filled(
                                        onPressed: () async {
                                          final currentUser =
                                              FirebaseAuth.instance.currentUser;

                                          if (currentUser != null) {
                                            final userId = currentUser.uid;
                                            final recipe = index[0];
                                            final savedRecipeOverflow =
                                                SavedRecipeModel(
                                              userid: userId,
                                              id: recipe.idMeal,
                                              name: recipe.strMeal,
                                              imageUrl: recipe.strMealThumb,
                                            );

                                            // Check if the recipe already exists for the current user
                                            final isRecipeAlreadySaved =
                                                savedRecipesData.any(
                                                    (savedRecipe) =>
                                                        savedRecipe.userid ==
                                                            userId &&
                                                        savedRecipe.name ==
                                                            savedRecipeOverflow
                                                                .name);

                                            if (isRecipeAlreadySaved) {
                                              // Show Snackbar indicating the item is already added
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${savedRecipeOverflow.name} is already saved',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        letterSpacing: 1),
                                                  ),
                                                  backgroundColor: AppColors
                                                      .success
                                                      .withOpacity(0.9),
                                                ),
                                              );
                                            } else {
                                              // Add the recipe to the list
                                              savedRecipesData
                                                  .add(savedRecipeOverflow);
                                              await saveRecipesToPrefs(
                                                  savedRecipesData, userId);
                                              // Show Snackbar indicating the item is saved
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${savedRecipeOverflow.name} saved',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        letterSpacing: 1),
                                                  ),
                                                  backgroundColor: AppColors
                                                      .success
                                                      .withOpacity(0.9),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        highlightColor: AppColors.primaryColor,
                                        icon:
                                            const Icon(SolarIconsBold.bookmark),
                                        iconSize: 18,
                                        color: AppColors.primaryColor,
                                        style: IconButton.styleFrom(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                      //   final currentUser =
                                      //       FirebaseAuth.instance.currentUser;
                                      //   if (currentUser == null) {
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(
                                      //       SnackBar(
                                      //         content: const Text(
                                      //           'Please log in to save recipes',
                                      //           style: TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 16,
                                      //           ),
                                      //         ),
                                      //         backgroundColor: AppColors
                                      //             .primaryColor
                                      //             .withOpacity(0.5),
                                      //       ),
                                      //     );
                                      //     return;
                                      //   }

                                      //   final userId = currentUser.uid;
                                      //   final recipe = index[0];
                                      //   final savedRecipe = SavedRecipeModel(
                                      //     userid: userId,
                                      //     id: recipe.idMeal,
                                      //     name: recipe.strMeal,
                                      //     imageUrl: recipe.strMealThumb,
                                      //   );

                                      //   // Fetch the saved recipes from preferences
                                      //   List<SavedRecipeModel> savedRecipes =
                                      //       await getSavedRecipesFromPrefs(
                                      //           userId);

                                      //   // Check if the recipe already exists in the saved list
                                      //   bool recipeExists = savedRecipes.any(
                                      //       (r) => r.id == savedRecipe.id);

                                      //   if (recipeExists) {
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(
                                      //       SnackBar(
                                      //         content: Text(
                                      //           '${savedRecipe.name} is already saved',
                                      //           style: const TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 16,
                                      //           ),
                                      //         ),
                                      //         backgroundColor: AppColors
                                      //             .primaryColor
                                      //             .withOpacity(0.5),
                                      //       ),
                                      //     );
                                      //   } else {
                                      //     // Add the recipe to the saved list
                                      //     savedRecipes.add(savedRecipe);
                                      //     await saveRecipesToPrefs(
                                      //         savedRecipes, userId);
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(
                                      //       SnackBar(
                                      //         content: Text(
                                      //           '${savedRecipe.name} saved',
                                      //           style: const TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 16,
                                      //           ),
                                      //         ),
                                      //         backgroundColor: AppColors
                                      //             .primaryColor
                                      //             .withOpacity(0.5),
                                      //       ),
                                      //     );
                                      //   }
                                      // },
                                      // icon: const Icon(
                                      //     SolarIconsOutline.bookmark),
                                      // iconSize: 18,
                                      // color: AppColors.primaryColor,
                                      // style: IconButton.styleFrom(
                                      //   backgroundColor: AppColors.white,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ), // Space for the image
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                          width: circleRadius,
                          height: circleRadius,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(32, 32, 32, 0.15),
                                offset: Offset(0, 8),
                                blurRadius: 26,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(circleBorderWidth),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: const CircleBorder(
                                  side: BorderSide(
                                      color: Color.fromARGB(66, 164, 164, 164)),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(index[0].strMealThumb),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 55,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber[200],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.004,
                                    horizontal: size.height * 0.008),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        rating, // Display the rating with one decimal place
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ), // Place your overlay widget here
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: const TextStyle(color: AppColors.textColor),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  static String randomRating() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _random = Random();
    var num = _random.nextDouble() * 50;
    var num2 = num.roundToDouble() + 1;
    return (num2 / 10).toString();
  }

  static String randomCookTime() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _random = Random();
    var num = _random.nextInt(10);
    num = _random.nextInt(50) + 25;
    return '$num min';
  }
}

class OverflowCard2 extends StatelessWidget {
  OverflowCard2({
    super.key,
    this.title = '',
    this.thumbnailUrl = '',
  });

  final String title;
  final String rating = OverflowCard.randomRating();
  final String cookTime = OverflowCard.randomCookTime();
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    const double circleRadius = 110.0;
    const double circleBorderWidth = 8.0;

    return FutureBuilder<List<MealsByCategorie>>(
      future: MealsApi.GetMealByCategory('Chicken'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final meals = snapshot.data!;
          return ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return GestureDetector(
                onTap: () {
                  int mealId = int.parse(meal.idMeal.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipePage(
                        mealId: mealId,
                        repository: RecipesRepository(),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  width: 330,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: circleRadius / 2.0),
                        child: Container(
                          height: 150,
                          width: 330,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(253, 255, 255, 255),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(32, 32, 32, 0.12),
                                offset: Offset(0, 8),
                                blurRadius: 26,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 0),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meal.strMeal.toString(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      height: 20,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 5,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, starIndex) {
                                          return Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber[600],
                                            size: 16,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGZhY2VzfGVufDB8fDB8fHww&auto=format&fit=cover&w=800&q=60',
                                                height: 37,
                                                width: 37,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const MyText(
                                              text: 'By Gordon Ramsay',
                                              color: Colors.black38,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            const Icon(
                                              SolarIconsOutline.alarm,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            MyText(
                                              text: cookTime,
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: circleRadius,
                        height: circleRadius,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(32, 32, 32, 0.064),
                              offset: Offset(0, 8),
                              blurRadius: 26,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(circleBorderWidth),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(
                                side: BorderSide(color: Colors.black26),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage(meal.strMealThumb.toString()),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(
            '${snapshot.error}',
            style: const TextStyle(color: AppColors.textColor),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class FoodCard extends StatelessWidget {
  final String title;
  final String rating = OverflowCard.randomRating();
  final String cooktime = OverflowCard.randomCookTime();
  final String thumbnailUrl;
  final bool isLoading; // Add a boolean flag to control the shimmer effect

  FoodCard({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    required this.isLoading, // Pass the isLoading flag as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Actual content
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(thumbnailUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(0, 0, 0, 0.3), // Semi-transparent black
                  Colors.black.withOpacity(0.7), // Solid black
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 70,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.004,
                              horizontal: size.height * 0.008),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  rating, // Display the rating with one decimal place
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 160, // Adjust the height as needed
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 90,
                              width: 140,
                              child: AutoSizeText(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: AppColors.textColor,
                                ),
                                maxLines: 5,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const MyText(
                              text: 'By Chef Dammy',
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 80,
                          ),
                          const Icon(
                            SolarIconsOutline.alarm,
                            size: 23,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 5),
                          MyText(
                            text: cooktime,
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            width: 2.h,
                          ),
                          IconButton.filled(
                            onPressed: () async {
                              const uuid = Uuid();
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;

                              if (currentUser != null) {
                                final userId = currentUser.uid;
                                final recipe = SavedRecipeModel(
                                  userid: userId,
                                  id: uuid.v4(),
                                  // Generate or use a unique id
                                  name: title,
                                  imageUrl: thumbnailUrl,
                                );

                                // Check if the recipe already exists for the current user
                                final isRecipeAlreadySaved =
                                    savedRecipesData.any((savedRecipe) =>
                                        savedRecipe.userid == userId &&
                                        savedRecipe.name == recipe.name);

                                if (isRecipeAlreadySaved) {
                                  // Show Snackbar indicating the item is already added
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${recipe.name} is already saved',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 1),
                                      ),
                                      backgroundColor:
                                          AppColors.success.withOpacity(0.9),
                                    ),
                                  );
                                } else {
                                  // Add the recipe to the list
                                  savedRecipesData.add(recipe);
                                  await saveRecipesToPrefs(
                                      savedRecipesData, userId);
                                  // Show Snackbar indicating the item is saved
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${recipe.name} saved',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 1),
                                      ),
                                      backgroundColor:
                                          AppColors.success.withOpacity(0.9),
                                    ),
                                  );
                                }
                              }
                            },
                            highlightColor: AppColors.primaryColor,
                            icon: const Icon(SolarIconsBold.bookmark),
                            iconSize: 18,
                            color: AppColors.primaryColor,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Shimmer effect overlaid on top when isLoading is true
        if (isLoading)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors
                    .grey[300], // Use a placeholder color while shimmering
              ),
            ),
          ),
      ],
    );
  }
}

class FoodCard2 extends StatelessWidget {
  final String title;
  final String rating = OverflowCard.randomRating();
  final String cooktime = OverflowCard.randomCookTime();
  final String thumbnailUrl;

  FoodCard2({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100, // Set the height to 200
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(0, 0, 0, 0.3), // Semi-transparent black
              Colors.black.withOpacity(0.7), // Solid black
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 50,
                  height: 25,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.7),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.004,
                        horizontal: size.height * 0.003,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$rating\t',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 10,
                    child: SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: title,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          const MyText(
                            text: 'By Chef Dammy',
                            fontSize: 12,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 80,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.004,
                            horizontal: size.height * 0.002,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  cooktime,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
