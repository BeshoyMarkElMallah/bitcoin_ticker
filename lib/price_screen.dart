import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/widgets/CryptoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  bool isWaiting = false;

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
        // print(selectedCurrency);
      },
      children: currenciesList.map<Text>((String value) {
        return Text(value);
      }).toList(),
    );
  }

  DropdownButton androidDropDown() {
    return DropdownButton(
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
      value: selectedCurrency,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  String bitcoinValue = '?';
  Map<String, String> coinValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: 'BTC',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? "?" : coinValues['BTC'],
          ),
          CryptoCard(
            cryptoCurrency: 'ETH',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? "?" : coinValues['ETH'],
          ),
          CryptoCard(
            cryptoCurrency: 'LTC',
            value: isWaiting ? "?" : coinValues['LTC'],
            selectedCurrency: selectedCurrency,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
