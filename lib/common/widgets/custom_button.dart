import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onSubmit,
    required this.text,
    this.isWarning = false,
    this.isLoading = false,
  });

  final VoidCallback onSubmit;
  final String text;
  final bool isLoading;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final Color? buttonColor = isWarning ? Colors.red[400]! : null;
    final Color? textColor = isWarning ? Colors.white : null;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? () {} : onSubmit,
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 3.0,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                  fontWeight: isWarning ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
