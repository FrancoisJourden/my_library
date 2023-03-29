
import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';

class GridBookElement extends StatelessWidget {
  const GridBookElement({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            if (book.cover != null)
              Expanded(
                child: Image.network(
                  HttpUtils.getBookCoverLocation(
                      book.cover ?? ""),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(book.title, textAlign: TextAlign.justify,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('${book.nbPages} pages'),
            ),
          ],
        ),
      ),
    );
  }
}


