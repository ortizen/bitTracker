import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => CoinData('BTC', 'USD')),
      ],
      child: Consumer<CoinData>(builder: (context, coinData, _) {
        return MaterialApp(
          theme: ThemeData.dark().copyWith(
              primaryColor: Colors.lightBlue,
              scaffoldBackgroundColor: Colors.white),
          home: Screen(),
        );
      }),
    );
  }
}
