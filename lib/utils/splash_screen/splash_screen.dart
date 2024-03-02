import 'package:cryptoratewheel/utils/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bitcoin_price/screen/bitcoin_price_screen.dart';
import '../colour_constants.dart';
import '../image_constant.dart';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CryptoRate Wheel",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ColourConstants.greenColor,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BitcoinPriceScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: ColourConstants.customGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CRYPTO RATE WHEEL",
                  style: StyleConstants.font24BoldYellow,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                          width: 2, color: ColourConstants.greenColor),
                      image: const DecorationImage(
                          image: AssetImage(ImageConstant.bitcoinImage),
                          fit: BoxFit.cover)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
