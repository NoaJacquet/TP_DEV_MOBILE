import 'package:flutter/material.dart';

import 'ecran1.dart';
import 'ecran2.dart';
import 'ecran3.dart';

class MyScaffold extends StatefulWidget {
  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Ecran1(),
    Ecran2(),
    Ecran3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppBar Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Couleur des icônes sélectionnées
        unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Historiques des scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Règles',
          ),
        ],
      ),
    );
  }
}
