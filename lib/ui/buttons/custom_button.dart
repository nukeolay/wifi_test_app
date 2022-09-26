import 'package:flutter/material.dart';

enum ButtonStatus {
  disabled,
  error,
  primary,
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.buttonState,
    required this.action,
    Key? key,
  }) : super(key: key);
  final String label;
  final ButtonStatus buttonState;
  final Function action;
  final colors = const [Colors.grey, Colors.red, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colors[buttonState.index]),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: buttonState == ButtonStatus.disabled ? null : () => action(),
        child: Text(label),
      ),
    );
  }
}
