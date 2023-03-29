import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';
import 'package:sqflite/sqflite.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
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
                          HttpUtils.getBookCoverLocation(book.cover ?? ""))),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(book.title, textAlign: TextAlign.justify)),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('${book.nbPages} pages')),
                FutureBuilder(
                    future: _isBookInLibrary(db, book),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          return const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text("Livre de votre bibliothèque"));
                        }
                        return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextButton(
                                onPressed: () => _addToLibrary(db, book),
                                child:
                                    const Text("Ajouter à ma bibliothèque")));
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

  Future<void> _addToLibrary(Database db, Book book) async {
    await DbUtils.registerBook(db, book);
  }

  Future<bool> _isBookInLibrary(Database db, Book book) {
    return DbUtils.existsInLibrary(db, book.isbn);
  }
}
