import 'package:flutter/material.dart';

class ItemTitle extends StatelessWidget {
  ItemTitle({
    @required this.onChanged,
    @required this.controller,
    @required this.onSubmit,
    @required this.checked,
  });

  final void Function(String) onChanged;
  final void Function(String) onSubmit;
  final TextEditingController controller;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Empty Item',
        counterText: '',
        border: InputBorder.none,
      ),
      style: TextStyle(
        decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
        color: checked
            ? Theme.of(context).primaryTextTheme.body1.color.withOpacity(0.45)
            : Theme.of(context).primaryTextTheme.body1.color,
      ),
      enabled: !checked,
      maxLength: 100,
      onChanged: onChanged,
      controller: controller,
      onSubmitted: onSubmit,
    );
  }
}
