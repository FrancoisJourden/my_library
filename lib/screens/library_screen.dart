import 'package:flutter/material.dart';
import 'package:my_library/components/libraryScreen/grid_book_element.dart';
import 'package:my_library/models/book.dart';
import 'package:sqflite/sqflite.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key, required this.db}) : super(key: key);
  final Database db;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  Future<List<Map<String, Object?>>> _getDbBook() async {
    return await widget.db.query("book");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDbBook(),
      builder: (BuildContext buildContext,
          AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        if (snapshot.hasData) {
          List<Book> books = snapshot.data?.map((e) => Book(title: e['title'] as String, nbPages: e['nb_pages'] as int, cover: e['cover'] as String?)).toList()??[];
          return GridView.builder(
            itemCount: snapshot.data?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.75),
            itemBuilder: (_, int index) {
              return GridBookElement(book: books[index]);
            },
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                Text(snapshot.error.toString())
              ],
            ),
          );
        }
        return const Center(
            child: SizedBox(
                width: 60, height: 60, child: CircularProgressIndicator()));
      },
    );
  }
}
