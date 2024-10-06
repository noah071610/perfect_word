import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontProvider = StateNotifierProvider<FontNotifier, String>((ref) {
  return FontNotifier();
});

class FontNotifier extends StateNotifier<String> {
  FontNotifier() : super('Noto Sans');

  void setFont(String font) {
    state = font;
  }
}
