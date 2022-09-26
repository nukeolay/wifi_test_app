import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/ui/buttons/custom_button.dart';

class ScanButton extends StatefulWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  bool _isInit = true;
  late WifiService _wifiService;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _wifiService = context.read<WifiService>();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 250.0),
        child: CustomButton(
          label: 'Scan',
          buttonState: ButtonStatus.primary,
          action: () {
            HapticFeedback.mediumImpact();
            _wifiService.scan();
          },
        ),
      ),
    );
  }
}
