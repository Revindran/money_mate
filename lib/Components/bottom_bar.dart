import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/Screens/Pages/analytics_screen.dart';
import 'package:money_mate/Screens/Pages/home_screen.dart';
import 'package:money_mate/Screens/Pages/notes_screen.dart';
import 'package:money_mate/Screens/Pages/settings_screen.dart';

/// This is the stateful widget that the main application instantiates.
class BottomHomeBar extends StatefulWidget {
  final int index;

  const BottomHomeBar({required this.index, Key? key}) : super(key: key);

  @override
  State<BottomHomeBar> createState() => _BottomHomeBarState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomHomeBarState extends State<BottomHomeBar> {
  late int i;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    i = widget.index;
    _selectedIndex = i;
  }

  final List<Widget> _widgetOptions = [
    HomePage(),
    NotesPage(),
    AnalyticsScreen(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_circle),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        onTap: _onItemTapped,
      ),
    );
  }
}
