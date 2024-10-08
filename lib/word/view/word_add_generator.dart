import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/widgets/country_image.dart';
import 'package:perfect_wordbook/common/widgets/custom_button.dart';

class AIWordForm extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String hintText;
  final String wordBookKey;
  final String wordLanguage;
  final VoidCallback generateWords;
  final VoidCallback addGeneratedWords;
  final TextEditingController controller;
  final bool isLoading;
  final List<WordCardModel> generatedCards;
  final List<bool> selectedCards;

  AIWordForm({
    Key? key,
    required this.title,
    required this.description,
    required this.hintText,
    required this.wordBookKey,
    required this.wordLanguage,
    required this.generateWords,
    required this.controller,
    required this.isLoading,
    required this.generatedCards,
    required this.selectedCards,
    required this.addGeneratedWords,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AIWordFormState();
}

class _AIWordFormState extends ConsumerState<AIWordForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _textFieldKey =
      GlobalKey<FormFieldState<String>>();

  void _validateAndSubmit(BuildContext context) {
    if (_textFieldKey.currentState!.validate()) {
      widget.generateWords();
    } else {
      showCustomToast(
          context: context, message: context.tr('please_enter_text'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CountryImage(language: widget.wordLanguage)
              ],
            ),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            SizedBox(height: 10),
            Expanded(
              child: (widget.generatedCards.isEmpty ||
                      widget.selectedCards.isEmpty)
                  ? TextFormField(
                      key: _textFieldKey,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                        border: InputBorder.none,
                        counterText: null,
                      ),
                      maxLines: null,
                      expands: true,
                      maxLength: 1000,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr('please_enter_text');
                        }
                        return null;
                      },
                      buildCounter: (
                        BuildContext context, {
                        required int currentLength,
                        required int? maxLength,
                        required bool isFocused,
                      }) {
                        return Text(
                          '$currentLength / $maxLength',
                          style: TextStyle(
                            fontSize: 14,
                            color: BODY_TEXT_COLOR,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: widget.generatedCards.length,
                      itemBuilder: (context, index) {
                        final card = widget.generatedCards[index];
                        return Row(
                          children: [
                            Expanded(
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        card.word,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              widget.selectedCards[index]
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough,
                                          color: widget.selectedCards[index]
                                              ? null
                                              : BODY_TEXT_COLOR,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        card.meaning,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: BODY_TEXT_COLOR,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                widget.selectedCards[index]
                                    ? CupertinoIcons.delete
                                    : CupertinoIcons.plus_app,
                                size: 20,
                                color: widget.selectedCards[index]
                                    ? Colors.red[400]
                                    : Colors.green,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.selectedCards[index] =
                                      !widget.selectedCards[index];
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
            ),
            SizedBox(height: 30),
            CustomButton(
              onSubmit: widget.generatedCards.isEmpty
                  ? () => _validateAndSubmit(context)
                  : widget.addGeneratedWords,
              text: widget.generatedCards.isEmpty
                  ? context.tr('auto_generate')
                  : context.tr('add_to_word_book'),
              isLoading: widget.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
