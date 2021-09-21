import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../contract_linking/election.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './election/index.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElectionContract>(
      // create: (_) => ContractLinking(),
      create: (_) => ElectionContract(),
      child: MaterialApp(
        title: 'Election APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.lightBlue[400],
            accentColor: Colors.blue),
        //home: HelloUI(),
        home: ElectionUI(),
        // home: LoginScreen(),
      ),
    );
  }
}
