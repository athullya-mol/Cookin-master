// ignore: unused_import
import 'dart:ffi';

import 'package:cookin/apis/recipe_reps.dart';
import 'package:cookin/widget/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:cookin/utils/utils.dart';
import 'package:cookin/widget/card.dart';
import 'package:cookin/widget/text.dart';

import '../models/item_model.dart';

class RecipePage extends StatefulWidget {
  const RecipePage(
      {Key? key, required this.mealId, required RecipesRepository repository})
      : _repository = repository,
        super(key: key);

  final int mealId;
  final RecipesRepository _repository;

  @override
  // ignore: library_private_types_in_public_api
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  bool checkTabController() {
    return _tabController.index == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent ,
        title: const Text('Recipe Details',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
            size: 30,
            color: AppColors.textColor,)),
        scrolledUnderElevation: 3,
        
      ),
      body: FutureBuilder<ItemModel>(
        future: widget._repository.fetchDetailMeals(widget.mealId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Meals>? index = snapshot.data?.meals;

            return NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FoodCard(
                            title:  index[0].strMeal.toString(),
                            isLoading: false,
                            thumbnailUrl: index[0].strMealThumb.toString(),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: MyText(
                              text: index[0].strMeal,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                           const SizedBox(height: 20),
                          Row(
                            children: [
                              const MyText(
                                text: ' Category : ',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              MyText(
                                text: index[0].strCategory,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                              
                              const Spacer(),
                              const MyText(
                                text: ' Area : ',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              MyText(
                                text: index[0].strArea,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                              ),
                              child: TabBar(
                                  controller: _tabController,
                                  labelColor: AppColors.textColor,
                                  labelPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  indicatorPadding: const EdgeInsets.symmetric(
                                      horizontal: -33, vertical: 8),
                                  unselectedLabelColor:
                                      AppColors.white,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
                                    color: AppColors.primaryColor,
                                  ),
                                  tabs: const [
                                    Tab(
                                      text: 'Ingredients',
                                    ),
                                    Tab(
                                      text: ' Procedure',
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                    child: IngredientCard2(
                      mealId: widget.mealId,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor.withOpacity(0.4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MyText(
                                  text: 'Follow the instructions below',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                                  
                              const SizedBox(height: 10),
                              Text(
                                index![0].strInstructions,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                  height: 1.95,
                                  letterSpacing: 0.1,
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
