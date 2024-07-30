import 'package:delivery_app/components/menu_list_item.dart';
import 'package:delivery_app/components/current_location.dart';
import 'package:delivery_app/components/delivery_info_box.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/pages/cart_page.dart';
import 'package:delivery_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/models/food.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/globals.dart' as globals;

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

  TabController? _tabController;
  List<dynamic> categories = [];

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('${globals.serverUrl}/api/restaurants/${widget.restaurantId}/menu/'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
        'Authorization' : 'Token ${prefs.getString('auth_token')}',
      },
    );
    
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      print("before print");
      print(response.body);
      final parsed = jsonDecode(response.body);
      print(parsed);
      print(parsed['categories']);
      setState(() {
        // for each dictionary in the categories list, get the name
        categories = parsed['categories'];
        _tabController = TabController(length: parsed['categories'].length, vsync: this);
      });
      
      
      print(parsed['food_items']);
      final food_items = parsed['food_items'] as List;
      print("Food_items ${food_items}");
      print('test');
      return food_items.map((e) => Food.fromJson(e)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load resturant menu');
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('The cart will empty if you leave. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Nevermind'),
          ),
          TextButton(
            onPressed: () {
              // pop until the home page
              Navigator.of(context).pop(true);
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Future<bool?> locationConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please confirm your location'),
        content: const CurrentLocation(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          clearCheckout();
          return;
        }
        if (CheckoutModel.instance.checkoutItems.isEmpty) {
          Navigator.of(context).pop();
          return;
        } else {
          final bool shouldLeave = await _showBackDialog() ?? false;
          print(shouldLeave);
          if (shouldLeave && context.mounted) {
            Navigator.of(context).pop();
            return;
          }
        }
        
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.restaurantName} Menu"),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                // Action for checkout
                var addressFromModel = AddressModel.instance.address;
                if (addressFromModel == '' || addressFromModel == null) {
                  final locationDialogue = await locationConfirmDialog() ?? false;
                  if (locationDialogue != true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Registration failed, please try again later"),
                      ),
                    );
                    return;
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(),
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
          child: FutureBuilder<List<Food>>(
            future: menuItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    constantWidgets(),
                    TabBar(
                      controller: _tabController,
                      // isScrollable: true,
                      tabs: List.generate(categories.length, (index) {
                        print('Tab $index');
                        return Tab(
                          text: '${categories[index]['name']}',
                        );
                      }),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: List.generate(categories.length, (index2) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              print(snapshot.data![index].category);
                              if (snapshot.data![index].category != categories[_tabController!.index]['id']) {
                                return const SizedBox.shrink();
                              }
                              return MenuItem(
                                menuItemObj: snapshot.data![index],
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
    
  }
  Widget constantWidgets() {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deliver now",
                style: TextStyle(
                  // color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              CurrentLocation(),
            ],
          ),
        ),
        DeliveryInfoBox(),
      ],
    );
  }
}