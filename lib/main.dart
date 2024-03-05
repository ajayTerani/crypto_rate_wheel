import 'package:cryptoratewheel/utils/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bitcoin_price/provider/bitcoin_price_provider.dart';
import 'bitcoin_price/screen/bitcoin_price_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BitcoinPriceProvider(context),
        child: MaterialApp(
          title: "CryptoRate Wheel",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: const SplashScreen(),
        ));
  }
}
