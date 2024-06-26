import "package:flutter/material.dart";
// used in resturant_page.dart
class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;
  final String resturantName;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title,
    required this.resturantName,
    });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 330,
      collapsedHeight: 100,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            // Navigate to the cart page
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        resturantName,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 24,
        ),
      ),
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