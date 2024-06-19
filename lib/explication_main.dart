import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Pour android c'est le titre de l'application lorsque l'application est en suspend
      //pour ios cela modifie le fichier ios > Runner > "Info.plist" 
      //cela definit le nom pour notre application

      // A VERIFIER
      //pour modifier le nom de l'application pour android
      //il suffit de changer la valeur de la propriété title
      //pour ios il faut directement modifier le fichier "Info.plist"
      title: 'Flutter Demo',
      //set la couleur, typo de l'application de manière globale
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //passe un paramettre au widget
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //syntaxe pour passé un paramettre dans le constructeur
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Theme.of(context) get le theme de material app
        //get la propriete colorScheme de ThemeData
        //puis get la propriete inversePrimary de colorScheme
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //réutilisation de la valeur passé en paramettre
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        //quand l'utilisateur longpress, il verra la valeur de la propriete
        //en version web il faut hover pour voir la valeur
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
