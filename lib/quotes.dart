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

class QuoteView extends StatelessWidget {
  Quote q;

  QuoteView(this.q, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.grey[350]),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0, bottom: 5.0),
            child: Text(q.text),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('${q.date}'),
          ),
        ],
      ),
    );
  }
}

class QuoteEnterer extends StatefulWidget {
  Quote _quote;

  Function() callback;

  QuoteEnterer({Key key, this.callback = null}) : super(key: key);

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
              if (quote == "")
                alert('Cannot save an empty quote', context);
              else {
                QuoteStorage.addQuote(quote);

                //Call the callback passed
                widget.callback?.call();

                quote = "";
                controller.text = "";
              }
            },
          ),
        ),
      ],
    );
  }
}

void alert(String alert, BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false, //User must tap button
    builder: (BuildContext context) => AlertDialog(
      //Proper alert
      title: Text('Alert'),
      content: Text(alert),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
