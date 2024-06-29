import 'dart:convert';

import 'package:delivery_app/components/my_current_location.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_drawer.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:delivery_app/components/restaurant_list_item.dart';
import 'package:delivery_app/components/resturant_search_bar.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  // tab controller
  // late TabController _tabController;

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this);
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  // temp data (will be fetched from the server, may independently fetch resturants
  // and food items once the user selects a resturant)
  // List<Restaurant> restaurants = [
  //   Restaurant(
  //     name: "Restaurant 1",
  //     description: "Resturant 1 description",
  //     address: "address 1",
  //     imagePaths: ["assets/images/resturants/previews/img1.png",],
  //     menu: [
  //       Food(
  //         name: "name",
  //         description: "description",
  //         price: 10.0,
  //         imagePath: "assets/images/food/previews/img1.png",
  //         category: FoodCategory.burger,
  //         availableAddons: [
  //           Addon(
  //             name: "Extra cheese",
  //             price: 1.0,
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  //   Restaurant(
  //     name: "Restaurant 2",
  //     description: "Resturant 2 description",
  //     address: "address 2",
  //     imagePaths: ["assets/images/resturants/previews/img1.png",],
  //     menu: [
  //       Food(
  //         name: "PIZZA!!!",
  //         description: "super delicious pizza",
  //         price: 30.0,
  //         imagePath: "assets/images/food/previews/img1.png",
  //         category: FoodCategory.pizza,
  //         availableAddons: [
  //           Addon(
  //             name: "Extra cheese",
  //             price: 1.0,
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // ];

  // list of resturants
  List<Restaurant> restaurants = [];

  // future to fetch resturants
  late Future<List<Restaurant>> futureRestaurants;

  @override
  void initState() {
    super.initState();
    futureRestaurants = fetchRestaurants();
  }

  // function to fetch resturants from the server
  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('http://192.168.0.100:8000/restaurants/'));
    
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      final results = parsed['results'] as List; 
      return results.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load resturants');
    }
  }

  // list of filtered resturants
  List<String> _filteredRestaurants = [];

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      body: RefreshIndicator( // pull to refresh, fetch resturants again
        onRefresh: () async {
          setState(() {
            futureRestaurants = fetchRestaurants();
          });
          await futureRestaurants;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text("Delivery App"),
              expandedHeight: 200,
              collapsedHeight: 70,
              centerTitle: true,
              flexibleSpace: const FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // current location
                      const MyCurrentLocation(),
                    ]
                  ),
                ),
                
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0), // Adjust as needed
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor( // needs looking into not working right now
                    isFullScreen: false,
                    viewOnChanged: (String value) {
                      // todo
                      // search for resturants
                      print("HELLO!!!");
                      print(value);
                      // filter resturants
                      if (value.isEmpty) {
                        _filteredRestaurants = [];
                      } else {
                        _filteredRestaurants = restaurants.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).map((e) => e.name).toList();
                      }
                      print(_filteredRestaurants);
                    },
                    builder: (BuildContext context, SearchController searchController) {
                      return SearchBar(
                        padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 25.0)),
                        controller: searchController,
                        hintText: "Search for resturants",
                        leading: const Icon(Icons.search),
                        onTap: () {
                          searchController.openView();
                        },
                      );
                    },
                    
                    // implement auto complete at some point
                    // https://api.flutter.dev/flutter/material/Autocomplete-class.html
                    suggestionsBuilder: (BuildContext context, SearchController controller) {
                      if (_filteredRestaurants.isEmpty) {
                        // Return a list with a single item indicating no suggestions
                        return [
                          ListTile(
                            title: Text('No suggestions found'),
                          ),
                        ];
                      } else {
                        // Return the list of suggestions
                        return _filteredRestaurants.map((String suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        }).toList();
                      }
                    }
                  ),
                ),
              ),
              
            ), 
            FutureBuilder<List<Restaurant>>(
              future: futureRestaurants, // This should return a Future<List<Restaurant>>
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList.builder(
                    itemBuilder: (BuildContext context, index) {
                      // Correctly access the restaurant at the current index
                      var restaurant = snapshot.data![index];
                      return Column(
                        children: [
                          RestaurantListItem(
                            restaurantId: restaurant.id, // id of the restaurant
                            restaurantName: restaurant.name,  // name of the restaurant
                            restaurantAddress: restaurant.address,
                            description: restaurant.description,
                            imagePath: restaurant.image, // single image (for now)
                          ),
                          SizedBox(height: 10.0),
                        ],
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                // show a loading spinner while the data is being fetched
                return const SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
      );
  }
}