import 'package:flutter/material.dart';

import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';

import 'package:sqflite/sqflite.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    Book book = args['book'] as Book;
    Database db = args['db'] as Database;

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                if (book.cover != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.network(
                      HttpUtils.getBookCoverLocation(book.cover ?? ""),
                      loadingBuilder:
                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(book.title, textAlign: TextAlign.justify)),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child:
                        Text('${book.nbPages} ${AppLocalizations.of(context)?.pages ?? "pages"}')),
                FutureBuilder(
                    future: _isBookInLibrary(db, book),
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: snapshot.data!
                                ? TextButton(
                                    onPressed: () => _deleteFromLibrary(db, book, context),
                                    child: Text(AppLocalizations.of(context)?.delete_library ??
                                        "Delete from my library"))
                                : TextButton(
                                    onPressed: () => _addToLibrary(db, book, context),
                                    child: Text(AppLocalizations.of(context)?.add_library ??
                                        "Add to my library")));
                      }

                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      return const CircularProgressIndicator();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addToLibrary(Database db, Book book, BuildContext context) async {
    await DbUtils.registerBook(db, book);
    if (context.mounted) Navigator.pop(context);
  }

  void _deleteFromLibrary(Database db, Book book, BuildContext context) async {
    await DbUtils.deleteBook(db, book.isbn);
    if (context.mounted) Navigator.pop(context);
  }

  Future<bool> _isBookInLibrary(Database db, Book book) {
    return DbUtils.existsInLibrary(db, book.isbn);
  }
}
