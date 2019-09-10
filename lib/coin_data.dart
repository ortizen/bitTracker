import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String _url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class CoinData {
  final String fiat;
  final String currency;
  String conversion;
  CoinData({this.fiat, this.currency});

  Future<void> getCoinData() async {
    String url = _url + fiat + currency;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      this.conversion = jsonResponse['last'].toString();
    } else {
      print(response.statusCode);
    }
  }

  String getConversion() {
    return this.conversion;
  }
}
