import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';
import 'package:sqflite/sqflite.dart';

class GridBookElement extends StatelessWidget {
  const GridBookElement({Key? key, required this.book, required this.db})
      : super(key: key);
  final Book book;
  final Database db;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () => _onclick(context),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (book.cover != null)
                  Expanded(
                      child: Image.network(
                          HttpUtils.getBookCoverLocation(book.cover ?? ""))),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(book.title, textAlign: TextAlign.justify)),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('${book.nbPages} pages')),
              ]
            ),
          ),
        ),
      ),
    );
  }

  void _onclick(BuildContext context) {
    Navigator.pushNamed(context, '/book_screen',
        arguments: {'book': book, 'db': db});
  }
}
