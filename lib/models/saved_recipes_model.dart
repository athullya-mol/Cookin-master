class SavedRecipeModel {
  final String userid;
  final String id;
  final String name;
  final String imageUrl;

  SavedRecipeModel({
    required this.userid,
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SavedRecipeModel.fromJson(Map<String, dynamic> json) {
    return SavedRecipeModel(
      userid: json['userid'] ?? '',
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
