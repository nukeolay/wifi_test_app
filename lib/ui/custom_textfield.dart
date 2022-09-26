import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.textEditingController,
    this.labelText,
  }) : super(key: key);

  final String? labelText;
  final TextEditingController? textEditingController;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      showCursor: true,
      autofocus: false,
      minLines: 1,
      maxLines: 1,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(4),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(4),
        ),
        labelText: widget.labelText,
      ),
    );
  }
}
