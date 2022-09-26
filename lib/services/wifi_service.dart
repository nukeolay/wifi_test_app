import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart'; // to use this service with provider (wrong but quick :-)
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

enum WifiStatus {
  init,
  scanning,
  scanFinished,
  connecting,
  connected,
  disconnecting,
  disconnected,
  disabled,
  permissionDenied,
  failed,
  unknown,
}

class WifiAccessPoint {
  final String ssid; // network name
  final int frequency; // frequency MHz
  final int signalStrength; // dBm
  final bool isConnected;
  const WifiAccessPoint({
    required this.ssid,
    required this.frequency,
    required this.signalStrength,
    required this.isConnected,
  });

  WifiAccessPoint copyWith({
    String? ssid,
    int? frequency,
    int? signalStrength,
    bool? isConnected,
  }) {
    return WifiAccessPoint(
      ssid: ssid ?? this.ssid,
      frequency: frequency ?? this.frequency,
      signalStrength: signalStrength ?? this.signalStrength,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

abstract class WifiService extends ChangeNotifier {
  Future<void> scan();
  Future<void> connect({required String ssid, required String password});
  Future<void> disconnect();
  List<WifiAccessPoint> get scannedNetworks;
  WifiAccessPoint? get connectedAccessPoint;
  WifiStatus get serviceStatus;
}

class WifiServiceImpl extends ChangeNotifier implements WifiService {
  final NetworkSecurity securityType = NetworkSecurity.WPA;
  WifiStatus _deviceStatus = WifiStatus.init;
  final List<WifiAccessPoint> _scannedNetworks = [];
  WifiAccessPoint? _connectedAccessPoint;
  bool _isScanning = false;

  @override
  Future<void> connect({
    required String ssid,
    required String password,
  }) async {
    _isScanning = false;
    _notifyListeners(WifiStatus.connecting);
    final isConnected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      joinOnce: true,
      security: securityType,
    );
    if (isConnected) {
      final accessPointIndex = _scannedNetworks
          .indexWhere((accessPoint) => accessPoint.ssid == ssid);
      _connectedAccessPoint =
          _scannedNetworks[accessPointIndex].copyWith(isConnected: true);
      _scannedNetworks[accessPointIndex] = _connectedAccessPoint!;
      _scannedNetworks.sort((a, b) => a.ssid.length.compareTo(b.ssid.length));
      _notifyListeners(WifiStatus.connected);
    } else {
      _notifyListeners(WifiStatus.failed);
    }
  }

  @override
  Future<void> disconnect() async {
    _notifyListeners(WifiStatus.disconnecting);
    final isDisconnected = await WiFiForIoTPlugin.disconnect();
    if (isDisconnected) {
      _notifyListeners(WifiStatus.disconnected);
    } else {
      _notifyListeners(WifiStatus.failed);
    }
    _isScanning = true;
  }

  @override
  WifiStatus get serviceStatus => _deviceStatus;

  @override
  Future<void> scan() async {
    _isScanning = true;
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isScanning) {
        final canStartScan =
            await WiFiScan.instance.canStartScan(askPermissions: true);
        switch (canStartScan) {
          case CanStartScan.yes:
            await WiFiScan.instance.startScan();
            _notifyListeners(WifiStatus.scanning);
            final accessPoints = await WiFiScan.instance.getScannedResults();
            final newScannedNetworks = accessPoints
                .map((e) => WifiAccessPoint(
                      ssid: e.ssid,
                      frequency: e.frequency,
                      signalStrength: e.level,
                      isConnected: false,
                    ))
                .toList();
            _scannedNetworks.clear();
            _scannedNetworks.addAll(newScannedNetworks);
            _scannedNetworks.sort((a, b) => a.ssid.compareTo(b.ssid));
            _notifyListeners(WifiStatus.scanFinished);
            break;
          case CanStartScan.noLocationServiceDisabled:
            _notifyListeners(WifiStatus.disabled);
            break;
          case CanStartScan.noLocationPermissionDenied:
            _notifyListeners(WifiStatus.permissionDenied);
            break;
          case CanStartScan.failed:
            _notifyListeners(WifiStatus.failed);
            break;
          default:
            log('default');
            _notifyListeners(WifiStatus.unknown);
            break;
        }
        return;
      }
    });
  }

  void _notifyListeners(WifiStatus status) {
    _deviceStatus = status;
    notifyListeners();
  }

  @override
  List<WifiAccessPoint> get scannedNetworks => _scannedNetworks;

  @override
  WifiAccessPoint? get connectedAccessPoint => _connectedAccessPoint;
}
