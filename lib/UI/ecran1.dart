import 'package:flutter/material.dart';
import 'shared_pref.dart';
import 'jeu.dart';

class Ecran1 extends StatefulWidget {
  @override
  _Ecran1State createState() => _Ecran1State();
}

class _Ecran1State extends State<Ecran1> {
  bool isConnected = false; // Variable pour suivre l'état de la connexion
  String? _loggedInUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    String? loggedInUser = await PreferencesManager.getLoggedInUser();
    setState(() {
      _loggedInUser = loggedInUser;
      isConnected = loggedInUser != null; // Initialise isConnected en fonction de l'état de connexion
    });
  }

  Future<bool?> _showLoginDialog(BuildContext context) async {
    TextEditingController pseudoController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    String errorMessage = '';

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connexion'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: pseudoController,
                  decoration: InputDecoration(labelText: 'Pseudo'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                ),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: Text('Se connecter'),
              onPressed: () async {
                String pseudo = pseudoController.text;
                String password = passwordController.text;
                String? savedPassword = await PreferencesManager.getPassword(pseudo);

                if (savedPassword == null || savedPassword != password) {
                  errorMessage = 'Pseudo ou mot de passe incorrect';
                  _showErrorMessage(errorMessage);
                  Navigator.of(context).pop(false);
                } else {
                  print('Connexion réussie');
                  setState(() {
                    _loggedInUser = pseudo;
                    isConnected = true; // Marquer comme connecté si la connexion réussie
                  });
                  await PreferencesManager.setLoggedInUser(pseudo);
                  Navigator.of(context).pop(true);
                }
              },
            ),
            ElevatedButton(
              child: Text('S\'inscrire'),
              onPressed: () async {
                String pseudo = pseudoController.text;
                String password = passwordController.text;
                String? savedPassword = await PreferencesManager.getPassword(pseudo);

                if (savedPassword != null) {
                  errorMessage = 'Le pseudo existe déjà';
                  _showErrorMessage(errorMessage);
                } else {
                  await PreferencesManager.saveUserCredentials(pseudo, password);
                  setState(() {
                    _loggedInUser = pseudo;
                    isConnected = true; // Marquer comme connecté si la connexion réussie
                  });
                  await PreferencesManager.setLoggedInUser(pseudo);
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await PreferencesManager.removeLoggedInUser();
    setState(() {
      _loggedInUser = null;
      isConnected = false; // Déconnexion, donc isConnected à false
    });
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 10,
              child: _loggedInUser != null
                  ? IconButton(
                icon: Icon(Icons.logout, color: Colors.black),
                onPressed: () {
                  _logout();
                },
              )
                  : Container(),
            ),
            Center(
              child: isConnected
                  ? Jeu() // Si connecté, affiche le jeu
                  : _loggedInUser != null
                  ? Text('Connecté en tant que $_loggedInUser')
                  : ElevatedButton(
                onPressed: () async {
                  bool? success = await _showLoginDialog(context);
                  if (success != null && success) {
                    setState(() {
                      isConnected = true; // Marquer comme connecté si la connexion réussie
                    });
                  }
                },
                child: Text('Se connecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
