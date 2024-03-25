import 'package:flutter/material.dart';

class Ecran1 extends StatelessWidget {

  TextEditingController _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Couleur de fond pour tout l'écran
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: 300.0, // Largeur du champ de saisie
            child: TextField(
              controller: _input,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Entrez votre nombre :",
              ),
              onSubmitted: (String value) {
                // Action à effectuer lorsque l'utilisateur appuie sur "Entrée"
                print("Entrée appuyée. Texte saisi : $value");
                _input.clear();
                // Vous pouvez effectuer ici toute action souhaitée.
              },
            ),
          ),
        ),
      ),
    );
  }
}

