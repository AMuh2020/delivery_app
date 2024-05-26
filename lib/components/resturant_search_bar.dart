import 'package:flutter/material.dart';

class ResturantSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const ResturantSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SearchBar(
        controller: controller,
        onChanged: (value) {
          // todo
          // search for resturants
        },
        hintText: hintText,
      ),
    );
  }
}