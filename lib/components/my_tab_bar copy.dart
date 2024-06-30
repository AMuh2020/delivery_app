import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  
  final TabController tabController;
  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: tabController,
        indicatorColor: Theme.of(context).colorScheme.secondary,
        labelColor: Theme.of(context).colorScheme.secondary,
        unselectedLabelColor: Theme.of(context).colorScheme.primary,
        tabs: [
          Tab(text: 'Menu'),
          Tab(text: 'Reviews'),
          Tab(text: 'Info'),
        ],
      )
    );
  }
}