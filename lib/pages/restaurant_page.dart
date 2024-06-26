import 'package:delivery_app/components/food_list_item.dart';
import 'package:delivery_app/components/my_current_location.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_drawer.dart';
import 'package:delivery_app/components/my_sliver_app_bar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
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

  // tab controller
  late TabController _tabController;

  late Future<List<Food>> menuItems;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    menuItems = fetchMenuItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Food>> fetchMenuItems() async {
    final response = await http.get(Uri.parse('http://192.168.100.69:8000/fooditems/'));
    
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      final results = parsed['results'] as List;
      print("RESULT FROM FOOD ${results}");
      return results.where((json) => json['restaurant'] == widget.restaurantId).map<Food>((json) => Food.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load resturants');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            MySliverAppBar(
              resturantName: widget.restaurantName,
              title: MyTabBar(tabController: _tabController),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    indent: 25,
                    endIndent: 25,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  // current location
                  const MyCurrentLocation(),

                  // description box - delivery fee and time
                  // rename at some point
                  const MyDescriptionBox()
                ]
                ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder<List<Food>>(
              future: menuItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FoodItem(
                        name: snapshot.data![index].name,
                        description: snapshot.data![index].description,
                        imagePath: snapshot.data![index].image,
                        price: double.parse(snapshot.data![index].price),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            // will be replaced with a list of menu items (need to make components for this) - done
            // data from the server
            // ListView.builder(
            //   itemCount: 10,
            //   itemBuilder: (context, index) {
            //     return FoodItem(
            //       name: 'Food Name',
            //       description: 'Food Description',
            //       imagePath: 'assets/images/resturants/food/burger1.jpg',
            //       price: 10.00,
            //     );
            //   },
            // ),
            Center(child: Text('Reviews')), // will be replaced with a list of reviews
            // todo - review list component
            Center(child: Text('Info')),
          ],
        ),
      ),
    );
  }
}