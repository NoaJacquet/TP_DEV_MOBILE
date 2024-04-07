import 'dart:math';
import 'package:flutter/material.dart';
import 'shared_pref.dart';

class Jeu extends StatefulWidget {
  @override
  _JeuState createState() => _JeuState();
}

class _JeuState extends State<Jeu> {
  TextEditingController _input = TextEditingController();
  Map<int, dynamic> _numbersList = {};
  late int _randomNumber;
  late int _selectedLevel;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _selectedLevel = 0; // Initialise le niveau sélectionné à 0
  }

  void _generateRandomNumber() {
    final Random random = Random();
    switch (_selectedLevel) {
      case 1:
        _randomNumber = random.nextInt(101); // Pour le niveau 1, des nombres de 0 à 100
        break;
      case 2:
        _randomNumber = random.nextInt(1001); // Pour le niveau 2, des nombres de 0 à 1000
        break;
      case 3:
        _randomNumber = random.nextInt(100000) + 1; // Pour le niveau 3, des nombres de 1 à 100000
        break;
    }
    print(_randomNumber);
  }

  void _checkNumber() {
    int? userInput = int.tryParse(_input.text);
    print("Nombre saisi : $userInput");
    print("Nombre aléatoire : $_randomNumber");
    if (userInput != null && userInput == _randomNumber) {
      print("yes");
      setState(() {
        _statusMessage = "Félicitations ! Vous avez deviné le bon nombre.";
      });
      _showResultDialog(); // Affiche la popup de félicitations
    } else if (userInput != null && userInput < _randomNumber) {
      _addNumberToList(userInput, "Trop petit");
    } else {
      _addNumberToList(userInput!, "Trop grand");
    }
    _input.clear();
  }

  void _addNumberToList(int number, String indicateur) {
    setState(() {
      _numbersList[number] = indicateur;
      _statusMessage = "Le nombre saisi est $number. C'est $indicateur.";
    });
  }

  void _logout(BuildContext context) async {
    await PreferencesManager.removeLoggedInUser();
    Navigator.pushNamed(context, '/ecran1'); // Redirige vers la page de connexion
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisissez le niveau'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLevel = 1; // Sélectionne le niveau 1
                      _generateRandomNumber(); // Génère un nouveau nombre aléatoire
                    });
                    Navigator.pop(context); // Ferme la popup
                  },
                  child: Text('Niveau 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLevel = 2; // Sélectionne le niveau 2
                      _generateRandomNumber(); // Génère un nouveau nombre aléatoire
                    });
                    Navigator.pop(context); // Ferme la popup
                  },
                  child: Text('Niveau 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLevel = 3; // Sélectionne le niveau 3
                      _generateRandomNumber(); // Génère un nouveau nombre aléatoire
                    });
                    Navigator.pop(context); // Ferme la popup
                  },
                  child: Text('Niveau 3'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showHistoryDialog(); // Affiche l'historique des parties
                    Navigator.pop(context); // Ferme la popup
                  },
                  child: Text('Historique'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHistoryDialog() async {
    String userId = await PreferencesManager.getLoggedInUser() ?? '';
    List<Map<String, dynamic>> games = await PreferencesManager.getGames(userId) ?? [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Historique des parties"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: games.map((game) {
                return ListTile(
                  title: Text("Niveau: ${game['level']}, Essais: ${game['attempts']}"),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context); // Ferme la popup d'historique
              },
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Félicitations !"),
          content: Text("Vous avez deviné le bon nombre."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la popup de félicitations
                setState(() {
                  _selectedLevel = 0; // Réinitialise le niveau sélectionné
                  _statusMessage = null; // Efface le message d'état
                  _numbersList.clear(); // Efface la liste des nombres
                });
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
      backgroundColor: Colors.blue, // Couleur de fond pour tout l'écran
      body: _selectedLevel == 0
          ? Center(
        child: ElevatedButton(
          onPressed: () {
            _showPopup(); // Affiche la popup pour choisir le niveau
          },
          child: Text('Commencer le jeu'),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _input,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Entrez un nombre",
              ),
              onSubmitted: (_) => _checkNumber(), // Appelle _checkNumber() lorsque la touche "Entrée" est pressée
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage ?? "", // Affiche le message d'état
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _numbersList.length,
                itemBuilder: (context, index) {
                  var cle = _numbersList.keys.elementAt(index);
                  var valeur = _numbersList[cle];
                  return ListTile(
                    title: Text("Nombre: $cle"),
                    subtitle: Text(valeur),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 280.0), // Augmente le padding
        child: FloatingActionButton(
          onPressed: () {
            _logout(context);
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
