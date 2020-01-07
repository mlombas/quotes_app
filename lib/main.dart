import 'package:flutter/material.dart';
import 'quotes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuoteEnterer input = QuoteEnterer();

    Widget mainColumn = Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 30,
                  child: input,
                ),
              ),
              Container(
                height: 30,
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text('Save'),
                  onPressed: () => QuoteStorage.addQuote(input.quote),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return MaterialApp(
      title: 'Quotes app',
      home: mainColumn,
    );
  }
}
