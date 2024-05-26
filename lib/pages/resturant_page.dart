import 'package:delivery_app/components/food_list_item.dart';
import 'package:delivery_app/components/my_current_location.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_drawer.dart';
import 'package:delivery_app/components/my_sliver_app_bar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:flutter/material.dart';

class ResturantPage extends StatefulWidget {
  // gets passed the resturant name
  final String resturantName;
  const ResturantPage({super.key, required this.resturantName});

  // todo
  // get resturant details from the server


  @override
  State<ResturantPage> createState() => _ResturantPageState();
}

class _ResturantPageState extends State<ResturantPage> with SingleTickerProviderStateMixin{

  // tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            MySliverAppBar(
              resturantName: widget.resturantName,
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
            // will be replaced with a list of menu items (need to make components for this)
            // data from the server
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return FoodItem(
                  name: 'Food Name',
                  description: 'Food Description',
                  imagePath: 'assets/images/resturants/food/burger1.jpg',
                  price: 10.00,
                );
              },
            ),
            Center(child: Text('Reviews')),
            Center(child: Text('Info')),
          ],
        ),
      ),
    );
  }
}