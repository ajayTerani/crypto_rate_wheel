import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colour_constants.dart';
import '../../utils/image_constant.dart';
import '../model/bitcoin_price_model.dart';
import '../provider/bitcoin_price_provider.dart';

class BitcoinPriceScreen extends StatelessWidget {
  const BitcoinPriceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BitcoinPriceProvider>(context);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      provider.fetchData();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: ColourConstants.customGradient
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
                              color: Colors.greenAccent,
                            ),
                            image: const DecorationImage(
                              image:AssetImage(ImageConstant.bitcoinImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Current Bitcoin Price',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        StreamBuilder<BitcoinPriceModel>(
                          stream: provider.bitcoinDataStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return Text(
                                data.rate.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator(
                                color: Colors.greenAccent,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<BitcoinPriceModel>(
                          stream: provider.bitcoinDataStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return Text(
                                data.description,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
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
                              color: Colors.greenAccent,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ListWheelScrollView(
                                itemExtent: 32,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  provider.setSelectedCurrency(
                                      provider.currencies[index]);
                                },
                                children: provider.currencies
                                    .map((currency) => Text(
                                          currency,
                                          style: const TextStyle(
                                            fontSize: 24,
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
                      color: Colors.greenAccent,
                    );
            },
          ),
        ),
      ),
    );
  }
}
