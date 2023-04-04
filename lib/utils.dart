import 'package:http/http.dart' as http;
import 'package:my_library/models/book.dart';
import 'package:sqflite/sqflite.dart';

class HttpUtils {
  static Future<http.Response> getBookData(String isbn) async{
    return http.get(Uri.parse('https://openlibrary.org/isbn/$isbn.json'));
  }

  static getBookCoverLocation(String coverId){
    return 'https://covers.openlibrary.org/b/id/$coverId.jpg';
  }
}

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
}