import 'dart:convert';
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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apikey = "4DC5C183-1F5F-45E6-9F86-B9EB1431FCA4";

class CoinData {
  Future getCoinData(String currency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '$coinAPIURL/$crypto/$currency?apikey=$apikey';

      http.Response response = await http.get(Uri.parse(requestURL));

      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        var lastPrice = decodeData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with get request';
      }
    }
    return cryptoPrices;
  }
}
