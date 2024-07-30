import 'package:decimal/decimal.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/pages/menu_item_page.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final Food menuItemObj;
  const MenuItem({
    super.key,
    required this.menuItemObj,
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
              menuItemData: menuItemObj,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     // color: Theme.of(context).colorScheme.secondary,
        //   ),
        //   height: 300, // Set the height of the image
        //   width: 100,
        //   child: Column(
        //     children: [
        //       Flexible(
        //         flex: 2,
        //         child: Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.only(
        //               topLeft: Radius.circular(10),
        //               topRight: Radius.circular(10),
        //             ),
        //             image: DecorationImage(
        //               image: NetworkImage(imagePath),
        //               fit: BoxFit.cover,
        //             ),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 10), // Add some spacing
        //       Flexible(
        //         flex: 1,
        //         child: Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.only(
        //               bottomLeft: Radius.circular(10.0),
        //               bottomRight: Radius.circular(10.0),
        //             ),
        //             color: Theme.of(context).colorScheme.primaryContainer,
        //           ),
        //           width: MediaQuery.of(context).size.width,
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text('${name}', style: Theme.of(context).textTheme.titleLarge),
        //                 Text('Price: ₦${price}'),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuItemObj.name,
                        style: TextStyle(
                          // color: Theme.of(context).colorScheme.primary,
                          // fontSize: 16,
                        ),
                      ),
                      Text(
                        'Price: ₦${menuItemObj.price}',
                        style: TextStyle(
                          // color: Theme.of(context).colorScheme.primary,
                          // fontSize: 16,
                        ),
                      ),
                      Text(
                        menuItemObj.description,
                        style: TextStyle(
                          // color: Theme.of(context).colorScheme.primary,
                          // fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  )
                ),
                const SizedBox(width: 10),
                Image.network(
                  menuItemObj.imagePath,
                  height: 120,
                  width: 120,
                ),
                // line
              ],
            ),
            Divider()
          ],
        )
      ),
    );
  }
}