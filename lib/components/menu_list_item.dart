import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/pages/menu_item_page.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;
  final int price;
  final Food menuItemData;
  const MenuItem({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.menuItemData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // todo
        // navigate to food page - with addons and add to cart button
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuItemPage(
              menuItemData: menuItemData,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Theme.of(context).colorScheme.secondary,
          ),
          height: 300, // Set the height of the image
          width: 100,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Add some spacing
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${name}', style: Theme.of(context).textTheme.titleLarge),
                        Text('Price: ₦${price}'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}