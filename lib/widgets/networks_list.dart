import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/widgets/avialable_networks.dart';

class NetworksList extends StatefulWidget {
  const NetworksList({Key? key}) : super(key: key);

  @override
  State<NetworksList> createState() => _NetworksListState();
}

class _NetworksListState extends State<NetworksList> {
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
    final scannedNetworks = _wifiService.scannedNetworks;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
        ),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: scannedNetworks.isEmpty
            ? const EmptyList()
            : AvialableNetworks(
                serviceStatus: _wifiService.serviceStatus,
                scannedNetworks: scannedNetworks,
              ),
      ),
    );
  }
}
