import 'package:flutter/material.dart';
import 'package:perfect_memo/common/constant/color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onSubmit,
    required this.text,
  });

  final VoidCallback onSubmit;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onSubmit,
        style: FilledButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: BUTTON_TEXT_COLOR,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
