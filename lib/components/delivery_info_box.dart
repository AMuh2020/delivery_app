import 'package:flutter/material.dart';
// used in resturant_page.dart

// to do: data from the server
// to do: make the delivery fee and delivery time dynamic
// delivery fee based on calculations
class DeliveryInfoBox extends StatefulWidget {
  const DeliveryInfoBox({super.key});

  @override
  State<DeliveryInfoBox> createState() => _DeliveryInfoBoxState();
}

class _DeliveryInfoBoxState extends State<DeliveryInfoBox> {
  // Delivery fee will be a constant but will come from server
  // Delivery time will be determined by the server using google maps api??
  // or restaurant's estimated prep time + delivery time
  @override
  Widget build(BuildContext context) {

    var myPrimaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
      fontSize: 20,
    );
    var mySecondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 20,
    );

    return Container(
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(25.0),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // // delivery fee
          // Column(
          //   children: [
          //     Text("\£3.00", style: myPrimaryTextStyle),
          //     Text("Delivery fee", style: mySecondaryTextStyle),
          //   ],
          // ),
          // delivery time
          Column(
            children: [
              Text("15-30 mins", style: myPrimaryTextStyle),
              Text("Delivery time", style: mySecondaryTextStyle),
            ],
          ),
        ],
      ),

    );
  }
}