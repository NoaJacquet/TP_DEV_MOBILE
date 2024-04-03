import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_pref.dart';


import 'ecran1.dart';
import 'ecran2.dart';
import 'ecran3.dart';
import 'jeu.dart'; // Importer le fichier jeu.dart

class MyScaffold extends StatefulWidget {
  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  int _currentIndex = 0;
  late Future<bool> _isLoggedInFuture; // Variable d'état pour stocker la future de connexion
  bool _isLoggedIn = false; // Variable d'état pour stocker le résultat de la connexion

  final List<Widget> _screens = [
    Ecran1(),
    Ecran2(),
    Ecran3(),
  ];

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = _checkLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppBar Title',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<bool>(
            future: _isLoggedInFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Affiche un indicateur de chargement tant que la future n'est pas résolue
                return Center(child: CircularProgressIndicator());
              } else {
                // Une fois que la future est résolue, met à jour l'état de connexion
                _isLoggedIn = snapshot.data ?? false;
                return _buildScreens();
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildScreens() {
    // Vérifier si l'utilisateur est connecté et si c'est le cas,
    // afficher la page de jeu, sinon afficher la page correspondant
    // à l'index sélectionné dans la barre de navigation.
    if (_isLoggedIn) {
      return _screens[_currentIndex];
    } else {
      return Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _screens[_currentIndex],
          );
        },
      );
    }
  }

  Future<bool> _checkLoggedInUser() async {
    // Utilisez votre gestionnaire de préférences pour vérifier si l'utilisateur est connecté
    return PreferencesManager.isLoggedIn();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
          label: 'Ecran 1',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Ecran 2',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Ecran 3',
        ),
      ],
    );
  }
}

