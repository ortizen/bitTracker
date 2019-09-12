import 'package:flutter/material.dart';
import 'constants.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

class Scream extends StatefulWidget {
  Scream({Key key}) : super(key: key);

  _ScreamState createState() => _ScreamState();
}

class _ScreamState extends State<Scream> {
  final List<CoinData> cryptos = [
    CoinData.withInit('BTC', 'USD'),
    CoinData.withInit('ETH', 'USD'),
    CoinData.withInit('LTC', 'USD')
  ];
  @override
  void initState() {
    super.initState();
    getConversions(cryptos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getCards(cryptos),
      ),
    );
  }

  Future<void> getConversions(List<CoinData> cryptos) async {
    for (CoinData crypto in cryptos) {
      await crypto.setConversion();
    }
  }

  List<Widget> getCards(List<CoinData> cryptos) {
    List<Widget> result = [];
    for (CoinData crypto in cryptos) {
      result.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                getString(crypto),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    result.add(Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? iOSPicker(cryptos) : androidDropDown(cryptos),
    ));
    return result;
  }

  String getString(CoinData crypto) {
    return '1 ${crypto.getCrypto()} = ${crypto.getConversion()} ${crypto.getCurrency()}';
  }

  DropdownButton<String> androidDropDown(List<CoinData> cryptos) {
    String currency;
    List<DropdownMenuItem<String>> curr = List<DropdownMenuItem<String>>();
    for (int i = 0; i < currenciesList.length; i++) {
      curr.add(
        DropdownMenuItem(
          child: Text(
            currenciesList[i],
          ),
          value: currenciesList[i],
        ),
      );
    }
    return DropdownButton<String>(
      value: currency,
      items: curr,
      onChanged: (value) {
        currency = value;
        for (CoinData crypto in cryptos) {
          crypto.setCurrency(currency);
          crypto.getConversion();
        }
      },
    );
  }

  CupertinoPicker iOSPicker(List<CoinData> cryptos) {
    String currency;
    List<Text> pickerList = List<Text>();
    for (String currency in currenciesList) {
      pickerList.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectdIndex) async {
        currency = currenciesList[selectdIndex];
        for (CoinData crypto in cryptos) {
          crypto.setCurrency(currency);
          await crypto.setConversion();
        }
      },
      children: pickerList,
    );
  }
}
