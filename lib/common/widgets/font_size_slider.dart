import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/provider/word_filter_provider.dart';

class FontSizeSlider extends ConsumerWidget {
  const FontSizeSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final wordFilter = ref.watch(wordFilterProvider);

    return Column(
      children: [
        SizedBox(height: 10),
        FlutterSlider(
          values: [wordFilter.fontSize['value']!],
          max: 5,
          min: 1,
          step: FlutterSliderStep(step: 1),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(
              color: PRIMARY_COLOR,
              shape: BoxShape.circle,
            ),
            child: Container(
              child: Icon(
                Icons.drag_handle,
                color: BUTTON_TEXT_COLOR,
                size: 20,
              ),
            ),
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBar: BoxDecoration(color: BORDER_DEEP_COLOR),
            inactiveTrackBar: BoxDecoration(color: Colors.grey[300]),
          ),
          hatchMark: FlutterSliderHatchMark(
            density: 1,
            labels: [
              FlutterSliderHatchMarkLabel(
                  percent: 0,
                  label: Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  )),
              FlutterSliderHatchMarkLabel(
                  percent: 25,
                  label: Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  )),
              FlutterSliderHatchMarkLabel(
                  percent: 50,
                  label: Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  )),
              FlutterSliderHatchMarkLabel(
                  percent: 75,
                  label: Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  )),
              FlutterSliderHatchMarkLabel(
                  percent: 100,
                  label: Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  )),
            ],
          ),
          tooltip: FlutterSliderTooltip(
            textStyle: TextStyle(fontSize: 16),
            leftPrefix: Icon(Icons.text_fields, size: 16),
            custom: (value) {
              String label;
              switch (value.toInt()) {
                case 1:
                  label = context.tr('very_small');
                  break;
                case 2:
                  label = context.tr('small');
                  break;
                case 3:
                  label = context.tr('medium');
                  break;
                case 4:
                  label = context.tr('large');
                  break;
                case 5:
                  label = context.tr('very_large');
                  break;
                default:
                  label = '';
              }
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(label, style: TextStyle(color: BLACK_COLOR)),
              );
            },
          ),
          onDragCompleted: (handlerIndex, lowerValue, upperValue) {
            ref
                .read(wordFilterProvider.notifier)
                .updateFontSizeSetting(lowerValue);
          },
        ),
      ],
    );
  }
}
