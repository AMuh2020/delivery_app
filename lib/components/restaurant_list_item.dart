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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 300,
            // width full screen width
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(
              children: [
                // image from internet
                Flexible(
                  flex: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Color.fromARGB(255, 51, 49, 49),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${restaurantName}', style: Theme.of(context).textTheme.titleLarge),
                          Text('${restaurantAddress}', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  )
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}