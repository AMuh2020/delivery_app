import 'package:delivery_app/pages/restaurant_page.dart';
import 'package:flutter/material.dart';

class RestaurantListItem extends StatelessWidget {
  final int restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final String description;
  final String imagePath;
  const RestaurantListItem({Key? key, required this.restaurantId, required this.restaurantName, required this.restaurantAddress ,required this.description, required this.imagePath}) : super(key: key);
  // when page clicked, make a request to the server to get the resturant details 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantPage(
              restaurantName: restaurantName,
              restaurantId: restaurantId,
            )
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary,
          ),
          height: 300, // Set the height of the image reel/gallery
          width: 100,
          child: Expanded(
            child: Column(
              children: [
                // image as array
                // Flexible(
                //   flex: 2,
                //   child: PageView.builder(
                //     itemCount: imagePaths.length,
                //     itemBuilder: (context, index) {
                //       // return Image.asset(
                //       //   imagePaths[index],
                //       //   fit: BoxFit.cover,
                //       // );
                //       return Image.network(
                //         imagePaths[index],
                //         fit: BoxFit.cover,
                //       );
                //     },
                //   ),
                // ),
                Flexible(
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10), // Add some spacing (left padding
                    Container(
                      width: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            restaurantAddress,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "rating: 4.5", 
                            style: Theme.of(context).textTheme.titleMedium
                          ),
                        ],
                      ),
                    ),
                  ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}