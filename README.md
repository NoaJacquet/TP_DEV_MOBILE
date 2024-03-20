import 'package:flutter/material.dart';

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'TD2',
            home: Scaffold(
                appBar: AppBar(
                title: Text('AppBar Title'),
                // Vous pouvez personnaliser d'autres propriétés de l'appBar selon vos besoins
                ),
            body: Center(
                child: Text('Contenu du Body'),
            ),
            ),
        );
    }
}
