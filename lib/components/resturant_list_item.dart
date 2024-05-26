import 'package:flutter/material.dart';

class ResturantListItem extends StatelessWidget {
  final String name;
  final String description;
  final List<String> imagePaths;
  const ResturantListItem({Key? key, required this.name, required this.description, required this.imagePaths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set the height of the image reel/gallery
      child: Row(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Image(
                  image: AssetImage(imagePaths[index]),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 10), // Add some spacing
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(description),
            ],
          )),
        ],
      ),
    );
  }
}