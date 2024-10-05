import 'package:flutter/material.dart';
import 'package:perfect_memo/common/constant/color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onSubmit,
    required this.text,
    this.isLoading = false,
  });

  final VoidCallback onSubmit;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? () {} : onSubmit,
        style: FilledButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          disabledBackgroundColor: PRIMARY_COLOR, // 추가된 부분
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
                  color: BUTTON_TEXT_COLOR,
                  strokeWidth: 3.0,
                ),
              )
            : Text(
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
