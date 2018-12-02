import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './scoped-models/main.dart';
import './pages/home.dart';
import './pages/admin.dart';
import './pages/add_link.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          accentColor: Colors.redAccent,
        ),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => HomePage(model),
          '/admin': (BuildContext context) => AdminPage(),
          '/addlink': (BuildContext context) => AddLinkPage(model),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage(model));
        },
      ),
    );
  }
}
