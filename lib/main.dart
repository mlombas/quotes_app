import 'package:flutter/material.dart';
import 'quotes.dart';
import 'storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes app',
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: MainWidget(),
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    //The quote enterer, every time a quote is entered redraw all
    QuoteEnterer input = QuoteEnterer(callback: () => setState(() {}));

    //List of quotes, needs to be like this because its made with futures
    Widget list = FutureBuilder(
      future: QuoteStorage.getQuotes(),
      builder: (context, snapshot) {
        Widget child;

        if (snapshot.hasData) {
          var quotes = snapshot.data;
          child = Expanded(
            child: ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) => QuoteView(quotes[index]),
            ),
          );
        } else {
          child = CircularProgressIndicator();
        }

        return Expanded(
          child: Column(
            children: <Widget>[
              Text('Stored quotes'),
              child,
            ],
          ),
        );
      },
    );

    return Center(
      child: Column(
        children: <Widget>[
          Container(
            child: input,
          ),
          list,
        ],
      ),
    );
  }
}
