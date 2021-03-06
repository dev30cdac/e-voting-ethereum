import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
import './screens/signin.dart';
import './screens/signup.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/background.jpg",
                fit: BoxFit.fill,
              ),
            ),
            _loginStatus == 1 ? Home() : SignIn()
          ],
        ),
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: true,
        routes: <String, WidgetBuilder>{
          '/signin': (BuildContext context) => new SignIn(),
          '/signup': (BuildContext context) => new SignUp(),
          '/home': (BuildContext context) => new Home(),
        });
  }

  var _loginStatus = 0;
  getPref() async {
    print("-----------init in home page-----");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getInt("value") != null) {
        _loginStatus = preferences.getInt("value")!;
      } else {
        _loginStatus = 0;
      }
    });
  }
}
