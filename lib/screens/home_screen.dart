import 'package:flutter/material.dart';
import 'package:my_library/screens/library_screen.dart';
import 'package:my_library/screens/scanner_screen.dart';
import 'package:my_library/screens/settings_screen.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
    const BottomNavigationBarItem(
        label: "Scanner", icon: Icon(Icons.barcode_reader)),
    const BottomNavigationBarItem(
        label: "settings", icon: Icon(Icons.settings)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Database> _loadDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_library_db');
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "create table book (isbn TEXT PRIMARY KEY, title TEXT, nb_pages INTEGER, cover TEXT);");
    });
    return db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My library")),
      body: FutureBuilder(
        future: _loadDB(),
        builder: (BuildContext context, AsyncSnapshot<Database> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<Widget> screens = [
              LibraryScreen(db: snapshot.data!),
              ScannerScreen(
                  onScanned: () => _onItemTapped(0), db: snapshot.data!),
              const SettingsScreen(),
            ];
            return screens[_selectedIndex];
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
              child: SizedBox(
                  width: 60, height: 60, child: CircularProgressIndicator()));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: navBarItems,
          onTap: _onItemTapped),
    );
  }
}
