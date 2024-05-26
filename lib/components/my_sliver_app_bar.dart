import "package:flutter/material.dart";

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title,
    });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      collapsedHeight: 100,
      floating: false,
      pinned: true,
      actions: [
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: () {},
        // ),
        // cart button
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      
      ],
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text('Delivery App'),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: child,
        ),
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0,top: 0),
      ),
    );
  }
}