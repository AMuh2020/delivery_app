import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

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
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(25.0),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // delivery fee
          Column(
            children: [
              Text("\£3.00", style: myPrimaryTextStyle),
              Text("Delivery fee", style: mySecondaryTextStyle),
            ],
          ),

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