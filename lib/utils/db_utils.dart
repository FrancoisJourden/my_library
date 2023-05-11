import 'package:my_library/models/book.dart';
import 'package:sqflite/sqflite.dart';
class DbUtils{
  static registerBook(Database db, Book book) async {
    await db.insert('book', {
      'isbn': book.isbn,
      'title': book.title,
      'nb_pages': book.nbPages,
      'cover': book.cover
    });
  }
  static deleteBook(Database db, String isbn) async {
    await db.delete('book', where: 'isbn=$isbn');
  }

  static Future<bool> existsInLibrary(Database db, String isbn) async {
    return (await db.query('book', where: 'isbn = $isbn')).isNotEmpty;
  }

  static Future<List<Map<String, Object?>>> getBooks(Database db) async {
    return await db.query("book");
  }

  static Future<List<Map<String, Object?>>> searchBook(Database db, String search) async {
    search = search.toLowerCase();
    return await db.query("book", where: "lower(title) like '%$search%'", orderBy: 'title', limit: 10);
  }
}