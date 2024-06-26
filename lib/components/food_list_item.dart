import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  const FoodItem({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // todo
        // navigate to food page - with addons and add to cart button
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary,
          ),
          height: 300, // Set the height of the image
          width: 100,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                )
              ),
              const SizedBox(width: 10), // Add some spacing
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${name}', style: Theme.of(context).textTheme.titleLarge),
                        Text('${description}', style: Theme.of(context).textTheme.bodyLarge),
                        Text('Price: \$${price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}