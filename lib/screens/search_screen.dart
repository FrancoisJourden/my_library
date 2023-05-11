import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/utils/db_utils.dart';
import 'package:sqflite/sqflite.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    Database db = args['db'] as Database;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Autocomplete<Book>(
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return TextFormField(
                autofocus: true,
                controller: textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)?.search_library,
                ),
                focusNode: focusNode,
                onFieldSubmitted: (String value) => onFieldSubmitted(),
              );
            },
            displayStringForOption: (Book book) => book.title,
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text == '') return const Iterable<Book>.empty();

              return (await DbUtils.searchBook(db, textEditingValue.text))
                  .map(
                    (book) => Book(
                        title: book['title'] as String,
                        isbn: book['isbn'] as String,
                        nbPages: book['nb_pages'] as int,
                        cover: book['cover'] as String?),
                  )
                  .toList();
            },
            onSelected: (Book selected) {
              Navigator.pushReplacementNamed(context, '/book',
                  arguments: {'book': selected, 'db': db});
            },
          ),
        ),
      ),
    );
  }
}
