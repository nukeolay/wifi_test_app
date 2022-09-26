import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_test/services/wifi_service.dart';
import 'package:wifi_test/widgets/connect_dialog.dart';

class AvialableNetworks extends StatelessWidget {
  final List<WifiAccessPoint> scannedNetworks;
  final WifiStatus serviceStatus;
  const AvialableNetworks({
    required this.serviceStatus,
    required this.scannedNetworks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: scannedNetworks.length,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final accessPoint = scannedNetworks[index];
        return Card(
          elevation: 0,
          child: ListTile(
            tileColor: serviceStatus == WifiStatus.connected
                ? Colors.grey
                : Colors.green,
            selectedTileColor: Colors.green,
            selected: accessPoint.isConnected,
            title: Text(
              accessPoint.ssid,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${accessPoint.frequency} MHz, ${accessPoint.signalStrength} dBm',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: serviceStatus == WifiStatus.connected
                ? null
                : (() {
                    HapticFeedback.mediumImpact();
                    accessPoint.isConnected
                        ? null
                        : _showConnectDialog(context, accessPoint.ssid);
                  }),
          ),
        );
      },
    );
  }

  void _showConnectDialog(BuildContext context, String networkName) =>
      showDialog(
        context: context,
        builder: (_) => ConnectDialog(
          context: context,
          networkName: networkName,
        ),
      );
}

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Press green button to scan for avialable wireless networks',
        style: TextStyle(fontSize: 26),
        textAlign: TextAlign.center,
      ),
    );
  }
}
