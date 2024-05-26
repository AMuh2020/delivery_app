import 'package:delivery_app/components/my_current_location.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_drawer.dart';
import 'package:delivery_app/components/my_sliver_app_bar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:flutter/material.dart';

class ResturantPage extends StatefulWidget {
  const ResturantPage({super.key});

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
      drawer: MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            MySliverAppBar(
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

                  // description box
                  const MyDescriptionBox()
                ]
                ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
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