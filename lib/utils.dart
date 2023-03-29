import 'package:http/http.dart' as http;

class HttpUtils {
  static Future<http.Response> getBookData(String isbn) async{
    return http.get(Uri.parse('https://openlibrary.org/isbn/$isbn.json'));
  }

  static getBookCoverLocation(String coverId){
    return 'https://covers.openlibrary.org/b/id/$coverId.jpg';
  }
}