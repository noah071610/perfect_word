import 'package:flutter/material.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:easy_localization/easy_localization.dart';

void confirmDialog({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  bool noConfirm = false,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          context.tr('cancel'),
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      if (!noConfirm)
                        TextButton(
                          child: Text(
                            context.tr('delete'),
                            style: TextStyle(
                              color: Colors.red[600],
                            ),
                          ),
                          onPressed: () {
                            onPressed();
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: -16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogTheme.backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: 20),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
