import 'package:flutter/material.dart';
import 'shared_pref.dart';

class Ecran1 extends StatefulWidget {
  @override
  _Ecran1State createState() => _Ecran1State();
}

class _Ecran1State extends State<Ecran1> {
  String? _loggedInUser;

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

                if (savedPassword != null && savedPassword == password) {
                  print('Connexion réussie');
                  setState(() {
                    _loggedInUser = pseudo;
                  });
                  await PreferencesManager.setLoggedInUser(pseudo);
                } else {
                  print('Identifiants incorrects');
                }

                if (savedPassword == null) {
                  await PreferencesManager.saveUserCredentials(pseudo, password);
                  setState(() {
                    _loggedInUser = pseudo;
                  });
                  await PreferencesManager.setLoggedInUser(pseudo);
                }

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
    return Container(
      color: Colors.blue,
      child: Center(
        child: _loggedInUser != null
            ? Text('Connecté en tant que $_loggedInUser')
            : ElevatedButton(
          onPressed: () {
            _showLoginDialog(context);
          },
          child: Text('Se connecter'),
        ),
      ),
    );
  }
}
