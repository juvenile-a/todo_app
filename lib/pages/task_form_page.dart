//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
//import 'package:syncfusion_flutter_core/tooltip_internal.dart';
//import 'package:syncfusion_flutter_core/core.dart';
//import 'package:syncfusion_flutter_core/core_internal.dart';
//import 'package:syncfusion_flutter_core/interactive_scroll_viewer_internal.dart';
//import 'package:syncfusion_flutter_core/legend_internal.dart';
//import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
//import 'package:syncfusion_flutter_core/tooltip_internal.dart';
//import 'package:syncfusion_flutter_core/zoomable_internal.dart';

class TaskFormPage extends StatelessWidget {
  final String? name;
  final int? priority;
  final DateTime? deadline;
  final String? memo;
  final int? completed;
  final ValueChanged<String> onChangedName;
  final ValueChanged<int> onChangedPriority;
  final ValueChanged<DateTime> onChangedDeadline;
  final ValueChanged<String> onChangedMemo;
  final ValueChanged<int> onChangedCompleted;

  const TaskFormPage({
    Key? key,
    this.name,
    this.priority = 3,
    this.deadline,
    this.memo = '',
    this.completed,
    required this.onChangedName,
    required this.onChangedPriority,
    required this.onChangedDeadline,
    required this.onChangedMemo,
    required this.onChangedCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildName(),
          buildPriority(),
          buildDeadline(context),
          buildMemo(),
          buildCompleted(),
        ],
      ),
    );
  }

  Widget buildName() {
    return TextFormField(
      maxLines: 1,
      initialValue: name,
      decoration: const InputDecoration(
        hintText: 'タスク名を入力しください',
        //filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo,
          ),
        ),
      ),
      validator: (name) => name != null && name.isEmpty ? 'タスク名は入力必須です' : null,
      onChanged: onChangedName,
    );
  }

  Widget buildPriority() {
    return Row(
      children: [
        const Text('優先度'),
        Expanded(
          child: SfSliderTheme(
            data: SfSliderThemeData(
              tooltipTextStyle: (const TextStyle(fontSize: 18)),
              thumbRadius: 14,
              activeDividerRadius: 6.0,
              inactiveDividerRadius: 4.0,
              inactiveDividerColor:
                  _sfSliderThemeDataColor(priority: priority!, opacity: 0.24),
              activeDividerColor:
                  _sfSliderThemeDataColor(priority: priority!, opacity: 0.76),
              activeTrackColor:
                  _sfSliderThemeDataColor(priority: priority!, opacity: 0.76),
              thumbColor: _sfSliderThemeDataColor(priority: priority!),
              tooltipBackgroundColor:
                  _sfSliderThemeDataColor(priority: priority!),
              inactiveTrackColor:
                  _sfSliderThemeDataColor(priority: priority!, opacity: 0.24),
              overlayColor:
                  _sfSliderThemeDataColor(priority: priority!, opacity: 0.12),
            ),
            child: SfSlider(
              //label: '$priority',
              interval: 1,
              //showTicks: true,
              showDividers: true,
              //showLabels: true,
              enableTooltip: true,
              tooltipShape: const SfPaddleTooltipShape(),
              //minorTicksPerInterval: 1,
              thumbIcon: Container(
                alignment: Alignment.center,
                child: Text(
                  priority.toString(),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              value: (priority ?? 3).toDouble(),
              min: 1,
              max: 5,
              //divisions: 4,
              onChanged: (priority) => onChangedPriority(priority.toInt()),
            ),
          ),
        ),
      ],
    );
  }

  Color _sfSliderThemeDataColor({
    required int priority,
    double opacity = 1.0,
  }) {
    Color color = Colors.white;
    switch (priority) {
      case 1:
        color = Colors.blue.withOpacity(opacity);
        break;
      case 2:
        color = Colors.green.withOpacity(opacity);
        break;
      case 3:
        color = Colors.orange.withOpacity(opacity);
        break;
      case 4:
        color = Colors.red.withOpacity(opacity);
        break;
      case 5:
        color = Colors.purple.withOpacity(opacity);
        break;
    }
    return color;
  }

  Widget buildDeadline(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('期限'),
        Expanded(
          child: TextButton(
            child: Text(DateFormat('yyyy/MM/dd E')
                .format(deadline!)), //yyyy/MM/dd HH:mm
            onPressed: () => showDeadlinePicker(context),
          ),
        ),
      ],
    );
  }

/*
  void showDeadlinePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: deadline,
            mode: CupertinoDatePickerMode.date, //dateAndTime
            minimumDate: DateTime.now().add(const Duration(days: 365) * -3),
            maximumDate: DateTime.now().add(const Duration(days: 365) * 3),
            use24hFormat: true,
            onDateTimeChanged: onChangedDeadline,
          ),
        );
      },
    );
  }
 */
  Future<void> showDeadlinePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: 365) * -1),
      lastDate: DateTime.now().add(const Duration(days: 365) * 3),
    );
    if (picked != null) {
      onChangedDeadline(picked);
    }
  }

  Widget buildMemo() {
    return TextFormField(
      maxLines: 5,
      initialValue: memo,
      decoration: const InputDecoration(
        hintText: 'メモ欄',
        //filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo,
          ),
        ),
      ),
      onChanged: onChangedMemo,
    );
  }

  Widget buildCompleted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 12),
        const Text('完了したらチェック！'),
        Row(children: [
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: (completed == 1) ? true : false,
              onChanged: (bool? value) =>
                  onChangedCompleted((value == true) ? 1 : 0),
            ),
          ),
          Text((completed == 1) ? '完了！' : '未完了…')
        ]),
      ],
    );
  }
}
