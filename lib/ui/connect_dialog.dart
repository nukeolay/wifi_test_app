import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/ui/buttons/custom_button.dart';
import 'package:wifi_test/ui/custom_textfield.dart';

class ConnectDialog extends StatefulWidget {
  final String networkName;
  final BuildContext context;
  const ConnectDialog({
    required this.networkName,
    required this.context,
    Key? key,
  }) : super(key: key);

  @override
  State<ConnectDialog> createState() => _ConnectDialogState();
}

class _ConnectDialogState extends State<ConnectDialog> {
  bool _isInit = true;
  late WifiService _wifiService;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _wifiService = widget.context.watch<WifiService>();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connect to network: ${widget.networkName}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          CustomTextField(
            labelText: 'Password',
            textEditingController: controller,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Cancel',
                    buttonState: ButtonStatus.error,
                    action: () {
                      HapticFeedback.vibrate();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    label: 'Connect',
                    buttonState: ButtonStatus.primary,
                    action: () {
                      HapticFeedback.vibrate();
                      _wifiService.connect(
                        ssid: widget.networkName,
                        password: controller.value.text,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
