import 'package:flutter/material.dart';

class FloatingLabelTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool autofocus;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const FloatingLabelTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _FloatingLabelTextFieldState createState() => _FloatingLabelTextFieldState();
}

class _FloatingLabelTextFieldState extends State<FloatingLabelTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: (widget.controller.text.isNotEmpty || _focusNode.hasFocus)
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          fontSize: 20.0,
          color: (widget.controller.text != '' || _focusNode.hasFocus)
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
