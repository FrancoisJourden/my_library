import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments.runtimeType != Book) {
      return const Text("Error Happened");
    }
    Book book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                if (book.cover != null)
                  Image.network(
                      HttpUtils.getBookCoverLocation(book.cover ?? "")),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(book.title, textAlign: TextAlign.justify),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('${book.nbPages} pages'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
