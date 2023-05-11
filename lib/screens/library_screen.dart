import 'package:flutter/material.dart';
import 'package:my_library/components/libraryScreen/grid_book_element.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils/db_utils.dart';
import 'package:sqflite/sqflite.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key, required this.db}) : super(key: key);
  final Database db;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: FutureBuilder(
          future: DbUtils.getBooks(widget.db),
          builder: (BuildContext buildContext, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child:BookGridWidget(data: snapshot.data, db: widget.db),
              );
            }
            if (snapshot.hasError) return ErrorWidget(snapshot: snapshot);
            return const LoadingWidget();
          },
        ));
  }

  Future<void> _onRefresh() async {
    setState(() {});
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: SizedBox(width: 60, height: 60, child: CircularProgressIndicator()));
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot<List<Map<String, Object?>>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 60),
        Text(snapshot.error.toString())
      ]),
    );
  }
}

class BookGridWidget extends StatelessWidget {
  const BookGridWidget({Key? key, this.data, required this.db}) : super(key: key);
  final List<Map<String, Object?>>? data;
  final Database db;

  @override
  Widget build(BuildContext context) {
    List<Book> books = data
            ?.map(
              (book) => Book(
                  title: book['title'] as String,
                  isbn: book['isbn'] as String,
                  nbPages: book['nb_pages'] as int,
                  cover: book['cover'] as String?),
            )
            .toList() ??
        [];
    if(books.isEmpty) return const Text("No book recorded");

    return GridView.builder(
        itemCount: data?.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.75),
        itemBuilder: (_, int index) => GridBookElement(book: books[index], db: db));
  }
}