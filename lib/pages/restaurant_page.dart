import 'package:delivery_app/components/menu_list_item.dart';
import 'package:delivery_app/components/current_location.dart';
import 'package:delivery_app/components/delivery_info_box.dart';
import 'package:delivery_app/components/home_page_drawer.dart';
import 'package:delivery_app/components/restaurant_app_bar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:delivery_app/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/models/food.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantPage extends StatefulWidget {
  // gets passed the resturant name
  final String restaurantName;
  // resturant id
  final int restaurantId;
  const RestaurantPage({super.key, required this.restaurantName, required this.restaurantId});

  // todo
  // get resturant details from the server
  // menu items, reviews, info


  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> with SingleTickerProviderStateMixin{
  late Future<List<Food>> menuItems;

  // array for checkout items
  List<Food> checkoutItems = [];

  @override
  void initState() {
    super.initState();
    menuItems = fetchMenuItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // fetch menu items from the server
  Future<List<Food>> fetchMenuItems() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.100:8000/restaurants/${widget.restaurantId}/menu/')
    );
    
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      print(response.body);
      final parsed = jsonDecode(response.body);
      final results = parsed as List;
      print("RESULT FROM FOOD ${results}");
      print('test');
      return results.map((e) => Food.fromJson(e)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load resturants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.restaurantName} Menu"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Action for checkout
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(),
                ),
              );
            },
          ),
        ],
      ),
      // backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            menuItems = fetchMenuItems();
          });
          await menuItems;
        },
        child: Column(
          children: [
            const CurrentLocation(),
            const DeliveryInfoBox(),
            Flexible(
              child: FutureBuilder<List<Food>>(
                future: menuItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return MenuItem(
                          name: snapshot.data![index].name,
                          description: snapshot.data![index].description,
                          imagePath: snapshot.data![index].image,
                          price: snapshot.data![index].price,
                          menuItemData: snapshot.data![index],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}