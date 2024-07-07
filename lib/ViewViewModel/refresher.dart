import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class Refresher extends ChangeNotifier {
  String Quote = "";
  String Author = "";

  void updater() async {
    var url = Uri.parse("https://stoic-quotes.com/api/quote");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print("Works");
    }
    var data = jsonDecode(response.body);
    print(data);
    Quote = (data["text"]);
    Author = (data["author"]);

    notifyListeners();
  }
}
