class Food {
  final int id;
  final int inventory;
  final String name;
  final String description;
  final String price;
  final String image;
  final String createdAt;
  final String updatedAt;
  final int restaurant;

  Food({
    required this.id,
    required this.inventory,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurant,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      inventory: json['inventory'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      restaurant: json['restaurant'], // id of the restaurant
    );
  }
}

// food categories
enum FoodCategory {
  burger,
  pizza,
  sushi,
  drink,
}

// food addons
class Addon {
  final String name;
  final double price;

  Addon({
    required this.name,
    required this.price,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'],
      price: json['price'],
    );
  }
}
