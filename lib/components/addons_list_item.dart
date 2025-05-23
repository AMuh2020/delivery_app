import 'package:decimal/decimal.dart';
import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';

class AddonsListItem extends StatefulWidget {
  final String name;
  final Decimal price;
  Widget checkbox; 

  AddonsListItem({
    Key? key,
    required this.name,
    required this.price,
    required this.checkbox,
  }) : super(key: key);

  @override
  State<AddonsListItem> createState() => _AddonsListItemState();
}

class _AddonsListItemState extends State<AddonsListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Ensures the Row takes minimum space
        children: [
          Text('₦${widget.price}'),
          widget.checkbox,
        ],
      )
    );
  }
}