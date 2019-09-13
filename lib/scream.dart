import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

class Scream extends StatefulWidget {
  Scream({Key key}) : super(key: key);

  _ScreamState createState() => _ScreamState();
}

class _ScreamState extends State<Scream> {
List <String> conversion = [];
String currency = 'USD';
List<String> responses= [];
 
Future<String> setConversion({String crypto = 'BTC', String currency = 'USD'}) async {
    String url = api + crypto + currency;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = convert.jsonDecode(response.body);
        conversion = jsonResponse['last'];
      });
      return 'Success!';
      
    } else {
      return 'Failure';
    }
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0; i< cryptoList.length; i++){
this.setConversion(crypto: cryptoList[i], currency: this.currency);
    }
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
    for (int i = 0; i < cryptoList.length; i++) {
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
                responses[i],
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

  String getString({String currency, String crypto, String conversion}) {
    setState(() {
       responses.add( '1 $crypto = $conversion $currency');
    });
    return 'Success!';
  }

  DropdownButton<String> androidDropDown() {
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
      onChanged: (value){
       this.currency = value;
       for(int i = 0; i < cryptoList.length; i ++){
        setState(() async {
          await setConversion(currency: this.currency, crypto: cryptoList[i]);
        }); 
       }
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
        this.currency = currenciesList[selectdIndex];
        for(int i = 0; i < cryptoList.length; i++){
setState(()async {
         await setConversion(currency: this.currency, crypto: cryptoList[i]);
       });
        } 
      },
      children: pickerList,
    );
  }
}
