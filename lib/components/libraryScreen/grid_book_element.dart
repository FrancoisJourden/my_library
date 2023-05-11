import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils/http_utils.dart';
import 'package:my_library/utils/image_utils.dart';
import 'package:sqflite/sqflite.dart';

class GridBookElement extends StatelessWidget {
  const GridBookElement({Key? key, required this.book, required this.db}) : super(key: key);
  final Book book;
  final Database db;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        child: Card(
          child: InkWell(
            onTap: () => _onclick(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                if (book.cover != null)
                  Expanded(
                    child: Hero(
                      tag: "book_cover_${book.isbn}",
                      child: Image.network(
                        HttpUtils.getBookCoverLocation(book.cover ?? ""),
                        errorBuilder: (context, object, stacktrace) => ImageUtils.errorBuilder(context),
                        loadingBuilder: ImageUtils.loadingBuilder,
                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(book.title, textAlign: TextAlign.justify)),
                Padding(
                    padding: const EdgeInsets.only(top: 16), child: Text('${book.nbPages} pages')),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _onclick(BuildContext context) {
    Navigator.pushNamed(context, '/book', arguments: {'book': book, 'db': db});
  }
}
