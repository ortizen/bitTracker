import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  static String currency = 'USD';
  static String crypto = 'BTC';
  static String conversion = '?';
  static List<CoinData> cryptos = [];
  @override
  void initState() {
    super.initState();
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
        children: getCards(),
      ),
    );
  }

  List<Widget> getCards() {
    List<Widget> result = [];
    for (crypto in cryptoList) {
      cryptos.add(CoinData(currency: currency, fiat: crypto));
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
                getString(cryptos.last),
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
      child: Platform.isIOS ? iOSPicker() : androidDropDown(),
    ));
    return result;
  }

  DropdownButton<String> androidDropDown() {
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
        setState(() {
          currency = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerList = List<Text>();
    for (String currency in currenciesList) {
      pickerList.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectdIndex) {
        setState(() {
          currency = currenciesList[selectdIndex];
        });
      },
      children: pickerList,
    );
  }

  String getString(CoinData last) {
    String conversion = last.getConversion();
    String result = '1 ${last.fiat} = $conversion ${last.currency}';
    return result;
  }
}
