import 'package:app_seu_bolso/form.dart';
import 'package:app_seu_bolso/home.dart';
import 'package:app_seu_bolso/mainScreen.dart';
import 'package:app_seu_bolso/salary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    routes: {
      Home.routeName: (context) => Home(),
      FormScreen.routeName: (context) => FormScreen(),
      Salary.routeName: (context) => Salary(),
    },
    home: MainScreen(),
  ));
}