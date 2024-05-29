import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair> [];

  bool isFavorite(pair) {
    return favorites.contains(pair);
  }

  void toggleFavorite() {
    if (isFavorite(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

/*
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //var resultText = appState.current.asSnakeCase;
    var pair = appState.current;

    IconData icon;
    if (appState.isFavorite(pair)) {
      icon = Icons.favorite;
    }
    else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random AWESOME idea 5:'),  // ← Example change.
            BigCard(pair: appState.current),
            SizedBox(height:10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: Icon(icon),
                  onPressed: () {
                    appState.toggleFavorite();
                  }, 
                  label: Text("Like"),
                  ),
                
                SizedBox(width:10),

                ElevatedButton(
                  onPressed: () {
                  appState.getNext();
                  print ("button pressed, ${appState.current.asSnakeCase}");
                  }, child: Text("Next")
                  ),
              ],
            )
          ],
        ),
      ),
    );

  }
}
*/


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  selectedIndex: selectedIndex,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  onDestinationSelected: (value) {
                    print('selected: $value');
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var listFavs = <Widget>[];

    listFavs.add( Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
          "You have ${appState.favorites.length} favorites.",
        ),
      )
    );

    appState.favorites.forEach(
      (element) { 
        listFavs.add(ListTile(
          leading: Icon(Icons.favorite),
          title: Text(element.asLowerCase)
        ));
     });

    

    return ListView(scrollDirection: Axis.vertical,
      children: listFavs,
    );

  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                  print ("appState: ${appState.current.asSnakeCase}");
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // var theme = ThemeData(colorScheme: 
    //   ColorScheme.fromSeed(seedColor: Colors.teal),
    //   textTheme: TextTheme(),
    // );
    //Color cardColor = Color.fromRGBO(255, 201, 7, 0.71);
    //theme.colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal)
    final style = theme.textTheme.displayMedium!.copyWith(
      color: Colors.white,
      // backgroundColor: Colors.lightBlue,
      // decorationColor: Color(value)
    );

    return Card(
      color: theme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}