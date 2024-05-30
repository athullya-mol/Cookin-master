import 'package:cookin/pages/search_page.dart';
import 'package:cookin/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchBarFood extends StatefulWidget {
  const SearchBarFood({super.key, required this.hintText, });

  final String hintText;

  @override
  State<SearchBarFood> createState() => _SearchBarFoodState();
}

class _SearchBarFoodState extends State<SearchBarFood> {
  List<String> suggestions = [
    'apple',
    'banana',
    'chicken',
    'tart',
    'fig',
    'cherry',
  ];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(querylistener);
  }

  @override
  void dispose() {
    searchController.removeListener(querylistener);
    searchController.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  void search(String Query) {
    final List<String> suggestionList = [];
    suggestionList.addAll(suggestions);
    setState(() {
      suggestionList
          .retainWhere((s) => s.toLowerCase().contains(Query.toLowerCase()));
    });
  }

  void querylistener() {
    search(searchController.text);
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 45,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              ),
          child: SearchBar(
            hintText: widget.hintText,
            hintStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                color: Colors.black45,
                fontSize: 15,
              ),
            ),
            controller: searchController,
            elevation: WidgetStateProperty.resolveWith<double?>((_) => 0),
            shadowColor: null,
            padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            onSubmitted: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(value: value),
                ),
              );
              clearSearch();
            },
            leading: const Icon(
              SolarIconsOutline.magnifier,
              color: AppColors.primaryColor,
            ),
            
          ),
        ),
      ],
    );
  }
}
      