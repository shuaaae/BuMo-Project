import 'package:flutter/material.dart';

class CustomSelectionWidget extends StatelessWidget {
  final String image;
  final String text;

  const CustomSelectionWidget({
    super.key,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 15,
        ),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
