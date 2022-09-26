import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/app/wifi_test.dart';
import 'package:wifi_test/services/wifi_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wifiService = WifiServiceImpl();

  runApp(MyApp(wifiService: wifiService));
}

class MyApp extends StatelessWidget {
  final WifiService _wifiService;
  const MyApp({required WifiService wifiService, Key? key})
      : _wifiService = wifiService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WiFi Test',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<WifiService>.value(value: _wifiService),
          ],
          child: const WifiTest(),
        ));
  }
}
