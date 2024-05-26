import 'package:delivery_app/pages/resturant_page.dart';
import 'package:flutter/material.dart';

class ResturantListItem extends StatelessWidget {
  final String resturantName;
  final String description;
  final List<String> imagePaths;
  const ResturantListItem({Key? key, required this.resturantName, required this.description, required this.imagePaths}) : super(key: key);
  // when page clicked, make a request to the server to get the resturant details 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResturantPage(
              resturantName: resturantName,
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
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: PageView.builder(
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10), // Add some spacing
              Flexible(
                flex: 1,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(resturantName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(description),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}