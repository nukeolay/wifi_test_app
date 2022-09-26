import 'package:flutter/material.dart';
import 'package:wifi_test/widgets/buttons/custom_button.dart';

class InfoDummyButton extends StatelessWidget {
  final String label;
  const InfoDummyButton({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 250.0),
        child: CustomButton(
          label: label,
          buttonState: ButtonStatus.disabled,
          action: () {},
        ),
      ),
    );
  }
}
