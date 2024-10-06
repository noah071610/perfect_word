import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'dart:ui' as ui;

String generateRandomKey() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      12, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

Icon getCardFormatIcon({required CardFormat format, double? size}) {
  switch (format) {
    case CardFormat.unchecked:
      return Icon(Icons.sentiment_neutral, color: Colors.grey, size: size);
    case CardFormat.memorized:
      return Icon(CupertinoIcons.checkmark_seal_fill,
          color: CupertinoColors.activeGreen, size: size);
    case CardFormat.difficulty:
      return Icon(CupertinoIcons.exclamationmark_shield_fill,
          color: const Color.fromARGB(255, 255, 96, 88), size: size);
    default:
      return Icon(CupertinoIcons.question_circle,
          color: CupertinoColors.systemGrey, size: size);
  }
}

CardFormat getCardNextFormat(CardFormat currentFormat) {
  switch (currentFormat) {
    case CardFormat.unchecked:
      return CardFormat.memorized;
    case CardFormat.memorized:
      return CardFormat.difficulty;
    case CardFormat.difficulty:
      return CardFormat.unchecked;
    default:
      return CardFormat.unchecked;
  }
}

Size getTextSize(BuildContext context, String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: ui.TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
