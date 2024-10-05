import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CountryImage extends StatelessWidget {
  const CountryImage({
    super.key,
    required this.language,
  });

  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Flag.fromString(
        language,
        width: 27,
        height: 18,
        fit: BoxFit.fill,
      ),
    );
  }
}
