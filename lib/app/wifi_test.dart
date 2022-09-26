import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/widgets/buttons/main_button.dart';
import 'package:wifi_test/widgets/networks_list.dart';

class WifiTest extends StatefulWidget {
  const WifiTest({Key? key}) : super(key: key);

  @override
  State<WifiTest> createState() => _WifiTest();
}

class _WifiTest extends State<WifiTest> {
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
    final serviceStatus = _wifiService.serviceStatus;
    log('$serviceStatus');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Test App'),
            Text(serviceStatus.toString()),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Header(label: 'Nearby wireless networks'),
              NetworksList(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: MainButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String label;
  const Header({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          )),
    );
  }
}
