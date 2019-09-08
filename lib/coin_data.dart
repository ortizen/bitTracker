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
  Future<String> getCoinData({String crypto, String fiat}) async {
    String result;
    String url = _url + crypto + fiat;
    var data;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      result = jsonResponse['last'].toString();
      return result;
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
