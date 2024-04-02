import 'package:flutter/material.dart';
import 'dart:math';

class Ecran1 extends StatefulWidget {
  @override
  _Ecran1State createState() => _Ecran1State();
}

class _Ecran1State extends State<Ecran1> {
  TextEditingController _input = TextEditingController();
  Map<int, dynamic> _numbersList = {};
  late int _randomNumber;

  @override
  void initState() {
    super.initState();
    _generateRandomNumber();
  }

  void _generateRandomNumber() {
    final Random random = Random();
    _randomNumber = random.nextInt(100);
    print(_randomNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Couleur de fond pour tout l'écran
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                width: 300.0,
                child: TextField(
                  autofocus: true,
                  controller: _input,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Entrez votre nombre :",
                  ),
                  onSubmitted: (String value) {
                    _checkNumber();
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _numbersList.length,
                itemBuilder: (context, index) {
                  var cle = _numbersList.keys.elementAt(index);
                  var valeur = _numbersList[cle];
                  return ListTile(
                    title: Text(cle.toString()),
                    subtitle: Text(valeur),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkNumber() {
    int? userInput = int.tryParse(_input.text);
    print("Nombre saisi : $userInput");
    print("Nombre aléatoire : $_randomNumber");
    if (userInput != null && userInput == _randomNumber) {
      print("yes");
    }
    else if (userInput != null && userInput < _randomNumber){
      _addNumberToList("Trop petit");
    }
    else{
      _addNumberToList("Trop grand");
    }
    _input.clear();
  }

  void _addNumberToList(String indicateur) {
    String input = _input.text;
    if (input.isNotEmpty) {
      int? number = int.tryParse(input);
      if (number != null) {
        setState(() {
          _numbersList[number] = indicateur;
        });
      }
    }
  }
}
