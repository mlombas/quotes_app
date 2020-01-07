import 'package:flutter/material.dart';
import 'storage.dart';

class Quote {
  String text;
  DateTime date;

  Quote(this.text, this.date);

  factory Quote.fromString(String s) {
    var split = s.split(';');
    var text = split[0];

    var date_chunks = split[1].split('-');
    //Reversed because the first parameter is the year and so
    var date = new DateTime(int.parse(date_chunks[2]),
        int.parse(date_chunks[1]), int.parse(date_chunks[0]));

    return new Quote(text, date);
  }

  @override
  String toString() {
    return '${text};${date.day}-${date.month}-${date.year}';
  }
}

class QuoteEnterer extends StatefulWidget {
  Quote _quote;

  @override
  _QuoteEntererState createState() => _QuoteEntererState();

  Quote get quote {
    return this._quote;
  }

  void set quote(Quote q) {
    this._quote = q;
  }
}

class _QuoteEntererState extends State<QuoteEnterer> {
  var quote;

  @override
  Widget build(BuildContext context) {
    var controller = new TextEditingController();
    var textField = TextField(
      decoration: InputDecoration(
        hintText: 'Enter quote',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(3.0),
      ),
      onChanged: (input) => quote = new Quote(input, new DateTime.now()),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: controller,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            height: 30,
            child: textField,
          ),
        ),
        Container(
          height: 30,
          alignment: Alignment.centerRight,
          child: FlatButton(
            child: Text('Save'),
            onPressed: () {
              QuoteStorage.addQuote(quote);
              controller.text = "";
            },
          ),
        ),
      ],
    );
  }
}
