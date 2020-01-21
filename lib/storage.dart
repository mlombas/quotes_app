import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'quotes.dart';

class QuoteStorage {
  static var _quotes;

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getFile(String name) async {
    final path = await _localPath;
    return File('$path/$name.csv');
  }

  static Future<List<Quote>> _readQuotes() async {
    print('enter');

    List<Quote> quotes = List<Quote>();
    var file = await _getFile('quotes');
    //Load file only if it exists, if not the list remains empty
    if (await file.exists()) {
      var stream =
          file.openRead().transform(utf8.decoder).transform(new LineSplitter());

      //The Quote constructor will parse the line
      await for (var line in stream) var q = new Quote.fromString(line);
    }

    return quotes;
  }

  static Future<void> loadIfNecessary() async {
    if (_quotes == null) _quotes = await _readQuotes();
  }

  static Future<List<Quote>> getQuotes() async {
    await loadIfNecessary();
    return _quotes;
  }

  static void addQuote(Quote q) async {
    //Get the quotes if they are not loaded yet
    await loadIfNecessary();
    _quotes.add(q);

    var file = await _getFile('quotes');
    var sink = file.openWrite();
    for (var q in _quotes) sink.write('$q\n');
    sink.close();
  }
}
