import 'package:flutter/material.dart';
import 'shared_pref.dart';

class Ecran1 extends StatefulWidget {
  @override
  _Ecran1State createState() => _Ecran1State();
}

class _Ecran1State extends State<Ecran1> {
  String? _loggedInUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Ajout de la clé globale pour le Scaffold

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    String? loggedInUser = await PreferencesManager.getLoggedInUser();
    setState(() {
      _loggedInUser = loggedInUser;
    });
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    TextEditingController pseudoController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    String errorMessage = '';

    return showDialog(
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
                if(errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Se connecter'),
              onPressed: () async {
                String pseudo = pseudoController.text;
                String password = passwordController.text;
                String? savedPassword = await PreferencesManager.getPassword(pseudo);

                if (savedPassword == null) {
                  errorMessage = 'Pseudo inexistant';
                  _showErrorMessage(errorMessage);
                } else if (savedPassword != password) {
                  errorMessage = 'Mot de passe incorrect';
                  _showErrorMessage(errorMessage);
                } else {
                  print('Connexion réussie');
                  setState(() {
                    _loggedInUser = pseudo;
                  });
                  await PreferencesManager.setLoggedInUser(pseudo);
                  Navigator.of(context).pop();
                  _showSuccessMessage('Connexion réussie');
                }
              },
            ),
            ElevatedButton(
              child: Text('S\'inscrire'),
              onPressed: () async {
                String pseudo = pseudoController.text;
                String password = passwordController.text;
                String? savedPassword = await PreferencesManager.getPassword(pseudo);

                if (savedPassword == null) {
                  await PreferencesManager.saveUserCredentials(pseudo, password);
                  setState(() {
                    _loggedInUser = pseudo;
                  });
                  await PreferencesManager.setLoggedInUser(pseudo);
                  Navigator.of(context).pop();
                  _showSuccessMessage('Inscription réussie');
                } else {
                  errorMessage = 'Le pseudo existe déjà';
                  _showErrorMessage(errorMessage);
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
    });
  }

  // Fonction pour afficher le message d'erreur dans une boîte de dialogue
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

  // Fonction pour afficher le message de succès avec SnackBar
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Durée d'affichage du message
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Ajout de la clé globale au Scaffold
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 10,
              child: _loggedInUser != null
                  ? IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _logout();
                },
              )
                  : Container(),
            ),
            Center(
              child: _loggedInUser != null
                  ? Text('Connecté en tant que $_loggedInUser')
                  : ElevatedButton(
                onPressed: () {
                  _showLoginDialog(context);
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
