import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'quotes.dart';

class QuoteStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getFile(String name) async {
    final path = await _localPath;
    return File('$path/$name.csv');
  }

  static Future<List<Quote>> readQuotes() async {
    var stream = (await _getFile('quotes'))
        .openRead()
        .transform(utf8.decoder)
        .transform(new LineSplitter());

    //The Quote constructor will parse the line
    List<Quote> quotes = List<Quote>();
    await for (var line in stream) {
      var q = new Quote.fromString(line);

      quotes.add(q);
    }

    return quotes;
  }

  static void addQuote(Quote q) async {
    var tempFile = await _getFile('temp');

    var tempSink = tempFile.openWrite();
		for(var quote in await readQuotes())
			tempSink.write('$quote\n');
    tempSink.write('$q\n');

    //Change existing file by temp one
    tempFile.rename((await _getFile('quotes')).path);

		print(await readQuotes());
  }
}
