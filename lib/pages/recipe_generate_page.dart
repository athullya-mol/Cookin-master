import 'dart:io';

import 'package:cookin/models/image_recipe_generate.dart';
import 'package:cookin/pages/recipe_generated_screen.dart';
import 'package:cookin/provider/provider/recipe_generate_dataprovider.dart';
import 'package:cookin/utils/pickimage.dart';
import 'package:cookin/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CreateRecipeScreen extends StatefulWidget {
  final Uint8List? recipeNameImage;
  const CreateRecipeScreen({super.key,required this.recipeNameImage});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController ingredientController = TextEditingController();
  late FocusNode focusNode = FocusNode();
  final List<String> inputIngredients = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TabController _tabController;

void _handleRecipeNavigation(String recipe) {
  if (recipe.isNotEmpty) {
    final recipeDataProvider = Provider.of<RecipeGenerateDataProvider>(context, listen: false);
    final Uint8List? recipeNameImage = recipeDataProvider.recipeNameImage;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RecipeGeneratedDetailScreen(
            recipe: recipe,
            image: context.read<RecipeGenerateDataProvider>().image,
            recipeNameImage: recipeNameImage!
          );
        },
      ),
    );
  } else {
    print('Recipe is empty or null');
  }
}

void selectImage(ImageSource source) async {
    final imagePicked = await pickImage(source);
    if (imagePicked != null) {
      context
          .read<RecipeGenerateDataProvider>()
          .setImage(RecipeImageData(imageRecipe: imagePicked.path));
    } else {
      print("No image selected");
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    ingredientController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Generate Recipe',
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
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 28,
              horizontal: 24,
            ),
            child: Center(
              child: Column(
                children: [
                  const Flexible(
                    child: Text(
                      "Are you looking for a recipe?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: TabBar(
                      labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple.shade900,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                      indicatorWeight: 5.0,
                      indicatorColor: Colors.deepPurple,
                      indicatorPadding: const EdgeInsets.all(4),
                      unselectedLabelColor: Colors.black,
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: 'By Ingredients',
                        ),
                        Tab(text: 'By Image'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildIngredientTab(),
                        _buildImageTab(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        final provider =
                            context.read<RecipeGenerateDataProvider>();
                        if (_tabController.index == 0) {
                          // Ingredient tab is selected
                          await provider.generatedIngredientsRecipe(inputIngredients,context);
                          _handleRecipeNavigation(provider.getRecipe);
                        } else if (_tabController.index == 1) {
                          // Image tab is selected
                          await provider.generateRecipeImageRecipe(
                              provider.image!.imageRecipe.toString(),context);
                          _handleRecipeNavigation(provider.getRecipe);
                        }
              
                        setState(() {
                          _isLoading = false;
                        });
                      
                        // if (provider.image != null) {
                        //   await provider.generateRecipeImageRecipe(
                        //       provider.image!.imageRecipe.toString());
              
                        //   if (provider.getImageRecipe.isNotEmpty) {
                        //     setState(() {
                        //       _isLoading = false;
                        //     });
                        //     Navigator.push(context, MaterialPageRoute(
                        //       builder: (context) {
                        //         return RecipeDisplayScreen(
                        //             recipe: provider.getImageRecipe,
                        //             image: provider.image);
                        //       },
                        //     ));
                        //   }
                        //   else if(provider.image == null){
                        //     String recipe = await provider.generatedIngredientsRecipe(inputIngredients);
              
                        //   if (recipe.isNotEmpty) {
                        //     setState(() {
                        //       _isLoading = false;
                        //     });
                        //     Navigator.push(context, MaterialPageRoute(
                        //       builder: (context) {
                        //         return RecipeDisplayScreen(
                        //           recipe: recipe,
                        //           image: null,
                        //         );
                        //       },
                        //     ));
                        //   } else {
                        //     setState(() {
                        //       _isLoading = false;
                        //     });
                        //     print('Recipe is empty or null');
                        //   };
              
                        //   }
                        //   else {
                        //     setState(() {
                        //       _isLoading = false;
                        //     });
                        //     print('No Data Found');
                        //   }
                        // } else {
                        //   setState(() {
                        //     _isLoading = false;
                        //   });
                        //   print("Error on generating recipe");
                        // }
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.primaryColor),
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              vertical: 18, horizontal: 40))),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Generate Recipe',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  
  Widget _buildIngredientTab() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: ingredientController,
                  autofocus: true,
                  focusNode: focusNode,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      setState(() {
                        inputIngredients
                            .add(ingredientController.text.toString());
                        focusNode.requestFocus();
                      });
                      ingredientController.clear();
                      print(inputIngredients);
                    } else {
                      return 'Please enter an ingredient';
                    }
                    return null;
                  },
                  cursorColor: Colors.white,
                  style: const TextStyle(fontSize: 20, letterSpacing: 1.4),
                  decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.1),
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      labelText: 'Enter the Ingredients you have..',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                          color: Colors.white, fontSize: 18, letterSpacing: 1)),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (ingredientController.text.isNotEmpty) {
                    setState(() {
                      inputIngredients
                          .add(ingredientController.text.toString());
                      focusNode.requestFocus();
                    });
                    ingredientController.clear();
                    print(inputIngredients);
                  }
                }
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                  ))),
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Ingredients you have added',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: inputIngredients.length,
            itemBuilder: (context, index) {
              return Card(
                shape: const RoundedRectangleBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10))
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                )),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.water,
                    color: Colors.deepPurple,
                    size: 16,
                  ),
                  title: Text(inputIngredients[index]),
                  titleTextStyle: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  trailing: IconButton(
                      onPressed: () {
                        if (index >= 0 && index < inputIngredients.length) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            backgroundColor: Colors.black,
                            barrierColor: Colors.black.withOpacity(0.41),
                            barrierDismissible: false,
                            text: 'Do you want to delete',
                            textColor: Colors.white,
                            titleColor: Colors.white,
                            confirmBtnText: 'Delete',
                            cancelBtnText: 'Cancel',
                            confirmBtnColor: Colors.deepPurple,
                            customAsset: 'assets/delete.gif',
                            onConfirmBtnTap: () {
                              setState(() {
                                inputIngredients.removeAt(index);
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'Ingredient Deleted!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.black,
                              ));
                              print(inputIngredients);
                            },
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.deepPurple,
                        size: 30,
                      )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageTab() {
    // Implement your image picking logic here
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _pickImageOptions();
                });
              },
              child: const Text("Pick an Image")),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Consumer<RecipeGenerateDataProvider>(
              builder: (context, provider, child) => provider.image != null
                  ? Image.file(
                      File(provider.image!.imageRecipe.toString()),
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'assets/select_image.gif',
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _pickImageOptions() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 30),
          title: const Text('Select an image'),
          backgroundColor: Colors.black,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  tooltip: 'Take a photo',
                  onPressed: () {
                    selectImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.deepPurple),
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  icon: const Icon(
                    Icons.camera_alt_sharp,
                    size: 30,
                  )),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                  tooltip: 'choose from gallery',
                  onPressed: () {
                    selectImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.deepPurple),
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  icon: const Icon(
                    Icons.perm_media_rounded,
                    size: 30,
                  )),
            ],
          ),
        );
      },
    );
  }
  
}
