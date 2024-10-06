import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color containerBackground;
  final Color buttonBackground;
  final Color buttonTextColor;

  CustomColors({
    required this.containerBackground,
    required this.buttonBackground,
    required this.buttonTextColor,
  });

  @override
  ThemeExtension<CustomColors> copyWith({Color? containerBackground}) {
    return CustomColors(
      containerBackground: containerBackground ?? this.containerBackground,
      buttonBackground: buttonBackground,
      buttonTextColor: buttonTextColor,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      containerBackground:
          Color.lerp(containerBackground, other.containerBackground, t)!,
      buttonBackground:
          Color.lerp(buttonBackground, other.buttonBackground, t)!,
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t)!,
    );
  }
}
