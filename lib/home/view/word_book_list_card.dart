import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';
import 'package:perfect_wordbook/common/provider/word_book_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfect_wordbook/common/model/word_book_list_model.dart';
import 'package:perfect_wordbook/common/model/word_book_model.dart';
import 'package:perfect_wordbook/common/utils/utils.dart';
import 'package:perfect_wordbook/common/widgets/confirm_dialog.dart';
import 'package:perfect_wordbook/common/widgets/country_image.dart';
import 'package:perfect_wordbook/common/widgets/custom_dialog.dart';
import 'package:perfect_wordbook/common/widgets/floating_label_text_field.dart';
import 'package:perfect_wordbook/common/constant/data.dart';
import 'package:easy_localization/easy_localization.dart';

/// COMP: 리스트 카드
class WordBookListCard extends ConsumerStatefulWidget {
  final WordBookListModel wordBookList;
  final bool isOnlyOneList;
  final bool isSystemWordBookListCard;

  const WordBookListCard({
    Key? key,
    required this.wordBookList,
    required this.isOnlyOneList,
    required this.isSystemWordBookListCard,
  }) : super(key: key);

  @override
  ConsumerState<WordBookListCard> createState() => _WordBookListCardState();
}

class _WordBookListCardState extends ConsumerState<WordBookListCard> {
  bool _isExpanded = true;
  final TextEditingController titleController = TextEditingController();
  String selectedLanguage = 'US'; // 기본값으로 영국 국기 설정

  /// COMP: 모달
  void _showCreateWordBookModal({
    required BuildContext context,
    String? originTitle,
  }) {
    if (originTitle != null) {
      titleController.text = originTitle;
    } else {
      titleController.text = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return CustomDialog(
          btnText: originTitle != null
              ? context.tr('edit')
              : context.tr('create_word_book'),
          title: originTitle != null
              ? context.tr('edit_category_name')
              : context.tr('new_word_book_title'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingLabelTextField(
                label: context.tr('word_book_title'),
                controller: titleController,
              ),
              if (originTitle == null) SizedBox(height: 16),
              if (originTitle == null)
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(
                    labelText: context.tr('select_language'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 1),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: theme.dropdownMenuTheme.textStyle,
                  icon: Icon(Icons.arrow_drop_down,
                      color: theme.colorScheme.primary),
                  items: languages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language['value'],
                      child: Row(
                        children: [
                          CountryImage(
                            language: language['value']!,
                          ),
                          SizedBox(width: 8),
                          Text(
                            language['label']!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                ),
            ],
          ),
          onTap: () {
            if (titleController.text.isEmpty) {
              showCustomToast(
                  context: context,
                  message: context.tr('enter_title'),
                  isError: true);
              return;
            }
            if (originTitle != null) {
              ref.read(wordBookListProvider.notifier).changeWordBooListTitle(
                  widget.wordBookList.key, titleController.text);
              showCustomToast(
                  context: context, message: context.tr('change_completed'));
            } else {
              final wordBookKey = generateRandomKey();
              ref.read(wordBookListProvider.notifier).addWordBook(
                  widget.wordBookList.key,
                  wordBookKey,
                  titleController.text,
                  selectedLanguage);

              ref
                  .read(targetWordBookProvider.notifier)
                  .initializeTargetWordBook(
                      widget.wordBookList.key, wordBookKey);

              context.go('/word_book');
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _deleteWordBookListDialog() {
    confirmDialog(
      context: context,
      onPressed: () {
        if (widget.isOnlyOneList) {
          showCustomToast(
              context: context, message: context.tr('at_least_one_category'));
        } else {
          ref.read(wordBookListProvider.notifier).removeWordBookList(
              widget.wordBookList.key,
              widget.wordBookList.wordBookList.map((e) => e.key).toList());
          showCustomToast(
              context: context, message: context.tr('delete_completed'));
        }
        Navigator.of(context).pop();
      },
      content: context.tr('confirm_delete_category'),
      title: context.tr('delete_category'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      color: theme.cardColor,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            tileColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                )),
            leading: widget.isSystemWordBookListCard
                ? Icon(CupertinoIcons.doc_text_search,
                    color: theme.primaryColor)
                : Icon(CupertinoIcons.book, color: theme.primaryColor),
            title: Text(
              widget.wordBookList.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: !widget.isSystemWordBookListCard
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showCreateWordBookModal(context: context);
                        },
                        icon: Icon(
                          CupertinoIcons.add,
                          color: theme.iconTheme.color,
                          size: 18.0,
                        ),
                        constraints:
                            const BoxConstraints(), // override default min size of 48px
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: theme.iconTheme.color,
                          size: 18.0,
                        ),
                        padding: EdgeInsets.zero,
                        offset: Offset(0, 20),
                        constraints:
                            const BoxConstraints(), // override default min size of 48px
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                        onSelected: (String result) {
                          switch (result) {
                            case 'add':
                              _showCreateWordBookModal(context: context);
                              break;
                            case 'edit':
                              _showCreateWordBookModal(
                                  context: context,
                                  originTitle: widget.wordBookList.title);
                              break;
                            case 'delete':
                              _deleteWordBookListDialog();
                              break;
                            default:
                          }
                        },
                        color: theme.cardColor,
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'add',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: theme.iconTheme.color,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  context.tr('add_word_book'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: theme.iconTheme.color,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  context.tr('change_title'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red[300]),
                                SizedBox(width: 8),
                                Text(context.tr('delete_category'),
                                    style: TextStyle(color: Colors.red[300])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (widget.wordBookList.wordBookList.isEmpty)
            GestureDetector(
              onTap: () {
                _showCreateWordBookModal(context: context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  context.tr('no_word_books_yet'),
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          AnimatedCrossFade(
            firstChild: Container(height: 0),
            secondChild: _buildExpandedList(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 150),
          ),
        ],
      ),
    );
  }

// COMP: 단어장 목록
  Widget _buildExpandedList() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: widget.wordBookList.wordBookList.asMap().entries.map((entry) {
        final int index = entry.key;
        final WordBookModel book = entry.value;
        final bool isLastItem =
            index == widget.wordBookList.wordBookList.length - 1;

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              bottom: isLastItem
                  ? BorderSide.none
                  : BorderSide(
                      color: theme.dividerColor,
                      width: 1.0,
                    ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: ListTile(
              leading: book.language != 'global'
                  ? CountryImage(
                      language: book.language,
                    )
                  : null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          getCardFormatIcon(
                            format: CardFormat.memorized,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${book.memorizedWordCount}/${book.wordCount}',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(width: 10.0),
                      Row(
                        children: [
                          getCardFormatIcon(
                            format: CardFormat.difficulty,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${book.difficultyWordCount}',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                ref
                    .read(targetWordBookProvider.notifier)
                    .initializeTargetWordBook(
                        widget.wordBookList.key, book.key);

                context.go('/word_book');
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
