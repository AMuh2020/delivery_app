import 'package:delivery_app/components/my_current_location.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_drawer.dart';
import 'package:delivery_app/components/my_sliver_app_bar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:delivery_app/components/resturant_list_item.dart';
import 'package:delivery_app/components/resturant_search_bar.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Delivery App",
      //     style: TextStyle(
      //       color: Theme.of(context).colorScheme.inversePrimary,
      //       fontSize: 24,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.shopping_cart),
      //       onPressed: () {
      //         // Navigate to the cart page
      //       },
      //     ),
      //   ],
      //   centerTitle: true,
      // ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text("Delivery App"),
            expandedHeight: 250,
            collapsedHeight: 70,
            centerTitle: true,
            actions: [
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
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
                  builder: (BuildContext context, SearchController searchController) {
                    return SearchBar(
                      padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 25.0)),
                      controller: searchController,
                      hintText: "Search for resturants",
                      leading: const Icon(Icons.search),
                      onTap: () {
                        searchController.openView();
                      },
                      onChanged: (value) {
                        // todo
                        // search for resturants
                        searchController.openView();
                      },
                    );
                  },
                  // implement auto complete at some point
                  // https://api.flutter.dev/flutter/material/Autocomplete-class.html
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  }
                ),
              ),
            ),
            
          ),
          SliverList.builder(
           itemBuilder: (BuildContext context, index) {
            return ResturantListItem(
                  // backend will provide these values, will also manage the sorting
                  resturantName: "name",
                  description: "description",
                  imagePaths: [
                    "assets/images/resturants/previews/img1.png",
                    "assets/images/flutter_logo.png",
                  ], // stored as assest for now, will be stored in the backend
                );
              },
              itemCount: 10,
            ),
        ],
      ),
      );
  }
}