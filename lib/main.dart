// // import 'package:flutter/material.dart';
// // import 'drawer.dart';
// // void main() => runApp(MyApp());

// // class MyApp extends StatelessWidget {
// // 	// This widget is the root of your application.
// // 	@override
// // 	Widget build(BuildContext context) {
// // 		return MaterialApp(
// // 			title: 'Flutter Demo',
// // 			theme: ThemeData(
// // 				primarySwatch: Colors.orange,
// // 			),
// // 			home: new MyHomePage(),
// // 		);
// // 	}
// // }

// import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';

// void main() => runApp(MyApp());

// class RandomWords extends StatefulWidget {
//   @override
//   RandomWordsState createState() => new RandomWordsState();
// }

// class RandomWordsState extends State<RandomWords> {
//    final _suggestions = <WordPair>[];
//   final _biggerFont = const TextStyle(fontSize: 18.0);
//   Widget _buildSuggestions() {
//     return ListView.builder(
//         padding: const EdgeInsets.all(10.0),
//         itemBuilder: /*1*/ (context, i) {
//           if (i.isOdd) return Divider(); /*2*/

//           final index = i ~/ 2; /*3*/
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(20)); /*4*/
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }
//   Widget _buildRow(WordPair pair) {
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('LPC Generator'),
//       ),
//       body: _buildSuggestions(),
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final words = WordPair.random();
//     return MaterialApp(
//       theme: ThemeData(
// 				primarySwatch: Colors.orange,
//         primaryColor: Colors.green
// 			),      
//       title: 'Welcome to MMH',
//       home: RandomWords(),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyHomePage extends StatefulWidget {
      MyHomePage({Key key, this.title}) : super(key: key);
      // This widget is the home page of your application. It is stateful, meaning
      // that it has a State object (defined below) that contains fields that affect
      // how it looks.
      // This class is the configuration for the state. It holds the values (in this
      // case the title) provided by the parent (in this case the App widget) and
      // used by the build method of the State. Fields in a Widget subclass are
      // always marked "final".
      final String title;
      @override
      _MyHomePageState createState() => _MyHomePageState();
    }

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 19.0, color: Colors.black);
  TextStyle butt = TextStyle(fontFamily: 'Roboto', fontSize: 25.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orangeAccent[700],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: butt.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(

        child: Container(
          color: Colors.white30,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 185.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 50.0),
                emailField,
                SizedBox(height: 10.0),
                passwordField,
                SizedBox(
                  height: 20.0,
                ),
                loginButon,
                SizedBox(
                  height: 105.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Market My House',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.orange,
          ),
          home: MyHomePage(title: 'Market My House Login'),
        );
      }
    }