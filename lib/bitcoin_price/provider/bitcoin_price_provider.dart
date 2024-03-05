import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';
import '../model/bitcoin_price_model.dart';

class BitcoinPriceProvider extends ChangeNotifier {
  late StreamController<BitcoinPriceModel> _bitcoinDataController;
  late Stream<BitcoinPriceModel> bitcoinDataStream;
  String _selectedCurrency = 'USD';
  final List<String> currencies = ['USD', 'EUR', 'GBP'];
  String get selectedCurrency => _selectedCurrency;


  BitcoinPriceProvider(BuildContext context) {
    _bitcoinDataController = StreamController<BitcoinPriceModel>.broadcast();
    bitcoinDataStream = _bitcoinDataController.stream;
    fetchData(context);

    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData(context);
    });
  }

  void setSelectedCurrency(String currency,BuildContext context) {
    _selectedCurrency = currency;
    fetchData(context);
  }

  void fetchData(BuildContext context) async {
    if (!await checkInternetConnectivity()) {
      showNoInternetDialog(context);
      return;
    }

    try {
      final response = await http.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));
      final data = jsonDecode(response.body)['bpi'];
      for (var currency in data.keys) {
        if (currency == _selectedCurrency) {
          _bitcoinDataController.add(BitcoinPriceModel.fromJson(data[currency]));
          break;
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text("Please check your internet connection"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bitcoinDataController.close();
    super.dispose();
  }
}
