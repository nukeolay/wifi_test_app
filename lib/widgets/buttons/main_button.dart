import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/widgets/buttons/disconnect_button.dart';
import 'package:wifi_test/widgets/buttons/scan_button.dart';
import 'package:wifi_test/widgets/buttons/info_dummy_button.dart';

class MainButton extends StatefulWidget {
  const MainButton({Key? key}) : super(key: key);

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _isInit = true;
  late WifiService _wifiService;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _wifiService = context.watch<WifiService>();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (_wifiService.serviceStatus) {
      case WifiStatus.init:
        return const ScanButton();
      case WifiStatus.connected:
        return const DisconnectButton();
      case WifiStatus.scanning:
        return const InfoDummyButton(label: 'Press network to connect');
      case WifiStatus.scanFinished:
        return const InfoDummyButton(label: 'Press network to connect');
      case WifiStatus.connecting:
        return const InfoDummyButton(label: 'Connecting...');
      case WifiStatus.disconnecting:
        return const InfoDummyButton(label: 'Disconnecting...');
      case WifiStatus.disconnected:
        return const InfoDummyButton(label: 'Disconnected');
      case WifiStatus.failed:
        return const InfoDummyButton(label: 'Press network to connect');
      case WifiStatus.unknown:
        return const InfoDummyButton(label: '...');
      default:
        return Text(_wifiService.serviceStatus.toString());
    }
  }
}
