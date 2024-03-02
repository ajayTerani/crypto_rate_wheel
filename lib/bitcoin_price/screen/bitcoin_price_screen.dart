import 'dart:async';
import 'dart:convert';
import 'package:cryptoratewheel/utils/colour_constants.dart';
import 'package:cryptoratewheel/utils/image_constant.dart';
import 'package:cryptoratewheel/utils/style_constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../model/bitcoin_price_model.dart';

class BitcoinPriceScreen extends StatefulWidget {
  const BitcoinPriceScreen({Key? key});

  @override
  _BitcoinPriceScreenState createState() => _BitcoinPriceScreenState();
}

class _BitcoinPriceScreenState extends State<BitcoinPriceScreen> {
  late StreamController<BitcoinPriceModel> _bitcoinDataController;
  late Stream<BitcoinPriceModel> _bitcoinDataStream;
  String _selectedCurrency = 'USD';
  final List<String> currencies = ['USD', 'EUR', 'GBP'];

  @override
  void initState() {
    super.initState();
    _bitcoinDataController = StreamController<BitcoinPriceModel>();
    _bitcoinDataStream = _bitcoinDataController.stream;

    fetchData();

    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _bitcoinDataController.close();
    super.dispose();
  }

  void fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));
      final data = jsonDecode(response.body)['bpi'];
      for (var currency in data.keys) {
        if (currency == _selectedCurrency) {
          _bitcoinDataController
              .add(BitcoinPriceModel.fromJson(data[currency]));
          break;
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: ColourConstants.customGradient,
        ),
        child: Center(
          child: StreamBuilder<BitcoinPriceModel>(
            stream: _bitcoinDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final bitcoinData = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: ColourConstants.greenColor),
                        image: const DecorationImage(
                            image: AssetImage(ImageConstant.bitcoinImage),
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
                          _selectedCurrency == 'USD'
                              ? Icons.attach_money
                              : _selectedCurrency == 'EUR'
                                  ? Icons.euro
                                  : Icons.currency_pound_sharp,
                          color: ColourConstants.whiteColor,
                          size: 35,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          bitcoinData.rate.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 36, color: ColourConstants.whiteColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bitcoinData.description,
                      style: TextStyle(
                          fontSize: 18, color: ColourConstants.whiteColor),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: ColourConstants.greenColor),
                      ),
                      child: Stack(
                        children: [
                          ListWheelScrollView(
                            itemExtent: 32,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedCurrency = currencies[index];
                                fetchData();
                              });
                            },
                            children: currencies
                                .map((currency) => Text(
                                      currency,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: currency == _selectedCurrency
                                            ? ColourConstants.whiteColor
                                            : ColourConstants.blackColor,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator(
                    color: Colors.greenAccent);
              }
            },
          ),
        ),
      ),
    );
  }
}
