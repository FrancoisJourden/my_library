import 'package:flutter/material.dart';

import 'package:my_library/screens/library_screen.dart';
import 'package:my_library/screens/scanner_screen.dart';
import 'package:my_library/screens/settings_screen.dart';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Database> _loadDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_library_db');
    Database db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "create table book (isbn TEXT PRIMARY KEY, title TEXT, nb_pages INTEGER, cover TEXT);");
    });
    return db;
  }

  @override
  Widget build(BuildContext context) {
    /* navbar Items */
    final List<BottomNavigationBarItem> navBarItems = [
      BottomNavigationBarItem(
          label: AppLocalizations.of(context)?.home, icon: const Icon(Icons.home)),
      BottomNavigationBarItem(
          label: AppLocalizations.of(context)?.scanner, icon: const Icon(Icons.barcode_reader)),
      BottomNavigationBarItem(
          label: AppLocalizations.of(context)?.settings, icon: const Icon(Icons.settings)),
    ];

    return FutureBuilder(
      future: _loadDB(),
      builder: (BuildContext context, AsyncSnapshot<Database> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final List<Widget> screens = [
            LibraryScreen(db: snapshot.data!),
            ScannerScreen(onScanned: () => _onItemTapped(0), db: snapshot.data!),
            const SettingsScreen(),
          ];

          return Scaffold(
            appBar: getAppBar(context, snapshot.data!),
            body: screens[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex, items: navBarItems, onTap: _onItemTapped),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              Text(snapshot.error.toString())
            ]),
          );
        }
        return const Center(
            child: SizedBox(width: 60, height: 60, child: CircularProgressIndicator()));
      },
    );
  }

  PreferredSizeWidget? getAppBar(BuildContext context, Database db) {
    switch (_selectedIndex) {
      case 1:
        return null;
      case 2:
        return AppBar(title: Text(AppLocalizations.of(context)?.app_name ?? "My Library"));
      default:
        return AppBar(
          title: Text(AppLocalizations.of(context)?.app_name ?? "My Library"),
          actions: [
            IconButton(onPressed: () => onSearchClick(context, db), icon: const Icon(Icons.search)),
          ],
        );
    }
  }

  void onSearchClick(BuildContext context, Database db) {
    Navigator.pushNamed(context, '/search', arguments: {'db': db});
  }
}
