import 'package:flutter/material.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:easy_localization/easy_localization.dart';

void confirmDialog({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            )),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        actions: <Widget>[
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
      );
    },
  );
}
