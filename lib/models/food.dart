import 'package:decimal/decimal.dart';
class Food {
  final int id;
  final int inventory;
  final String name;
  final String description;
  final Decimal price;
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
      price: Decimal.parse(json['price']),
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      restaurant: json['restaurant'], // id of the restaurant
    );
  }
  Map<String, dynamic> toJson(Food foodObj) {
    // Initialize the addons map
    // Map<String, dynamic> addonsMap = {};
    // for (var addon in foodObj.addons) {
    //   addonsMap[addon.name] = {
    //     'id': addon.id,
    //     'price': addon.price,
    //   };
    // }
    List<Map<String, dynamic>> addonsList = addons.map((addon) => {
    'id': addon.id,
    'name': addon.name,
    'price': addon.price,
  }).toList();

    // Construct the main data map
    Map<String, dynamic> data = {
      'id': foodObj.id,
      'name': foodObj.name,
      'price': foodObj.price,
      // Assuming 'restaurantId' is a separate property you intended to use
      'restaurant': foodObj.id, 
      'quantity': foodObj.quantity,
      'addons': addonsList,
    };

    return data;
  }
}


// food addons
class Addon {
  final int id;
  final String name;
  final Decimal price;

  Addon({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      price: Decimal.parse(json['price']),
    );
  }
}
