class Order {
  final int id;
  final int userID;
  final int restaurantID;
  final String restaurantName;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  Order({
    required this.id,
    required this.userID,
    required this.restaurantID,
    required this.restaurantName,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.deliveredAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userID: json['user'],
      restaurantID: json['restaurant'],
      restaurantName: json['restaurant_name'],
      total: double.tryParse(json['total'])!,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at']) : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'user': userID,
  //     'restaurant': restaurantID,
  //     'restaurant_name': restaurantName,
  //     'total': total,
  //     'delivered': delivered,
  //     'created_at': createdAt.toIso8601String(),
  //     'delivered_at': deliveredAt.toIso8601String(),
  //   };
  // }
}