import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colour_constants.dart';
import '../../utils/image_constant.dart';
import '../../utils/style_constants.dart';
import '../provider/bitcoin_price_provider.dart';
import '../model/bitcoin_price_model.dart';

class BitcoinPriceScreen extends StatelessWidget {
  const BitcoinPriceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BitcoinPriceProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchData(context);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: ColourConstants.customGradient,
        ),
        child: Center(
          child: Consumer<BitcoinPriceProvider>(
            builder: (context, provider, child) {
              return provider.bitcoinDataStream != null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          width: 2,
                          color: ColourConstants.greenColor),
                      image: const DecorationImage(
                          image: AssetImage(
                              ImageConstant.bitcoinImage),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Current Bitcoin Price',
                      style: StyleConstants.bitcoinScreenHeading),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        provider.selectedCurrency == 'USD'
                            ? Icons.attach_money
                            : provider.selectedCurrency == 'EUR'
                            ? Icons.euro
                            : Icons.currency_pound_sharp,
                        color: ColourConstants.whiteColor,
                        size: 35,
                      ),
                      const SizedBox(width: 5),
                      StreamBuilder<BitcoinPriceModel>(
                        stream: provider.bitcoinDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data!;
                            return Text(
                              data.rate.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 36,
                                  color: ColourConstants.whiteColor),
                            );
                          } else {
                            return const CircularProgressIndicator(
                                color: Colors.greenAccent);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<BitcoinPriceModel>(
                    stream: provider.bitcoinDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Text(
                          data.description,
                          style: TextStyle(
                              fontSize: 18,
                              color: ColourConstants.whiteColor),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          width: 2,
                          color: ColourConstants.greenColor),
                    ),
                    child: Stack(
                      children: [
                        ListWheelScrollView(
                          itemExtent: 32,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            provider.setSelectedCurrency(provider.currencies[index], context);
                          },
                          children: provider.currencies
                              .map((currency) => Text(
                            currency,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : const CircularProgressIndicator(
                  color: Colors.greenAccent);
            },
          ),
        ),
      ),
    );
  }
}
