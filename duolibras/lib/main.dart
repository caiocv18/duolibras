import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/SignInPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningWidget.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Service.instance.getUser().then((user) {
  //   print(user.name);
  // });
  SharedFeatures.instance.isLoggedIn = true;
  // Service.instance.getTrail().then((trail) {
  //   print(trail.title);
  //   Service.instance.getSectionsFromTrail().then((sections) {
  //     print(sections.first.title);
  //     Service.instance
  //         .getModulesFromSectionId(sections.first.id)
  //         .then((modules) {
  //       print(modules.first.title);
  //       Service.instance
  //           .getExercisesFromModuleId(sections.first.id, modules.first.id)
  //           .then((modules) {
  //         print(modules.first.question);
  //       });
  //     });
  //   });
  // });

  runApp(MyApp());
  // Database.instance.saveUser(User(name: "Rangel", id: "123")).then((value) {
  //   print(value);
  // });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  LearningViewModelProtocol _createViewModel() {
    final LearningViewModelProtocol viewModel = LearningViewModel();
    return viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignInPage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
