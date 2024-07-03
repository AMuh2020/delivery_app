import 'dart:convert';
import 'package:delivery_app/components/current_location.dart';
import 'package:delivery_app/components/delivery_info_box.dart';
import 'package:delivery_app/components/home_page_drawer.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:delivery_app/components/restaurant_list_item.dart';
import 'package:delivery_app/components/resturant_search_bar.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:delivery_app/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  

  // future to fetch resturants
  late Future<List<Restaurant>> futureRestaurants;

  @override
  void initState() {
    super.initState();
    futureRestaurants = fetchRestaurants();
  }

  // function to fetch resturants from the server
  Future<List<Restaurant>> fetchRestaurants() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('${globals.serverUrl}/api/restaurants/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
    );
    
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      final results = parsed['results'] as List; 
      return results.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load resturants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: HomePageDrawer(),
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
              title: const Text("AMAL Delivery"),
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
                      CurrentLocation(),
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
                      // todo
                      // filter resturants
                      
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
                    suggestionsBuilder: (BuildContext context, SearchController controller) {
                      // todo
                      // implement auto complete
                      return [];
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
                return const  SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator()
                  )
                );
              },
            ),
          ],
        ),
      ),
      );
  }
}