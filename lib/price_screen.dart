import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _currency = 'USD';
  String _crypto = 'BTC';
  String _conversion = '?';
  CoinData data = CoinData();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getConversion(crypto: this._crypto, currency: this._currency);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
                  '1 $_crypto = $_conversion $_currency',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
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
      value: _currency,
      items: curr,
      onChanged: (value) {
        setState(() {
          _currency = value;
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
          _currency = currenciesList[selectdIndex];
        });
      },
      children: pickerList,
    );
  }

  Future<void> getConversion({String currency, String crypto}) async {
    var conversion = await data.getCoinData(crypto: crypto, fiat: currency);
    setState(() {
      this._conversion = conversion.toString();
    });
  }
}
