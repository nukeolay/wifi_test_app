import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/ui/buttons/custom_button.dart';

class DisconnectButton extends StatefulWidget {
  const DisconnectButton({Key? key}) : super(key: key);

  @override
  State<DisconnectButton> createState() => _DisconnectButtonState();
}

class _DisconnectButtonState extends State<DisconnectButton> {
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
          label: 'Disconnect',
          buttonState: ButtonStatus.error,
          action: () {
            HapticFeedback.mediumImpact();
            _wifiService.disconnect();
          },
        ),
      ),
    );
  }
}
