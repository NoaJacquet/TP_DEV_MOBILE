import 'package:flutter/material.dart';

class Ecran3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white, // Couleur de fond
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Règles du Jeu du Nombre Magique',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Couleur du texte
                ),
              ),
              SizedBox(height: 20),
              Text(
                '1. Un nombre magique est choisi par l\'ordinateur.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                '2. Le joueur propose un nombre.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                '3. L\'ordinateur indique si le nombre proposé est trop grand, trop petit ou égal au nombre magique.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                '4. Le joueur ajuste ses propositions en conséquence jusqu\'à ce qu\'il trouve le nombre magique.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}