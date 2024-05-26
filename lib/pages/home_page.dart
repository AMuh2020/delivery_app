import 'package:delivery_app/components/my_current_location.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_drawer.dart';
import 'package:delivery_app/components/my_sliver_app_bar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:delivery_app/components/resturant_list_item.dart';
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
            expandedHeight: 300,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("placeholder"),
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
            
          ),
          SliverList.builder(
           itemBuilder: (BuildContext context, index) {
                return Container(
                  color: Colors.lightBlue[100 * (index % 9)],
                  height: 300,
                  width: 100,
                  child: ResturantListItem(
                    // backend will provide these values, will also manage the sorting
                    name: "name",
                    description: "description",
                    imagePaths: ["assets/images/resturants/resturant1/previewimg1.png"],
                  ),
                );
              },
              itemCount: 10,
            ),
        ],
      ),
      );
  }
}