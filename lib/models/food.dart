class Food {
  final int id;
  final int inventory;
  final String name;
  final String description;
  final int price;
  final String image;
  final String createdAt;
  final String updatedAt;
  final int restaurant;
  // these two variables are not required as they are not from api
  // they are added to the model to keep track of the quantity and addons for checkout
  int quantity;
  List<Addon> addons;

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
    this.addons = const [],
    this.quantity = 0,
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
  final int price;

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
