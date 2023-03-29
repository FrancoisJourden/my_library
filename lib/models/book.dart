class Book {
  String isbn;
  String title;
  int nbPages;
  String? cover;

  Book({required this.isbn, required this.title, required this.nbPages, this.cover});
}