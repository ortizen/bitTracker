import 'dart:convert' as convert;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class CoinData with ChangeNotifier {
  String _crypto;
  String _currency;
  String _conversion;

  CoinData();
  CoinData.withInit(String crypto, String currency) {
    this._crypto = crypto;
    this._currency = currency;
  }
  Future<void> setConversion() async {
    String url = api + _crypto + _currency;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      this._conversion = jsonResponse['last'].toString();
      notifyListeners();
    } else {
      print(response.statusCode);
    }
  }

  String getConversion() {
    notifyListeners();
    return this._conversion;
  }

  String getCrypto() {
    notifyListeners();
    return this._crypto;
  }

  String getCurrency() {
    notifyListeners();
    return this._currency;
  }

  void setCurrency(String currency) {
    this._currency = currency;
    notifyListeners();
  }

  void setCrypto(String crypto) {
    this._crypto = crypto;
    notifyListeners();
  }
}
