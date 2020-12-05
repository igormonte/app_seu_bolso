import 'package:app_seu_bolso/home.dart';
import 'package:app_seu_bolso/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, AsyncSnapshot<User> snapshot){
      if(!snapshot.hasData)
        return Login();      
      if(snapshot.data == null)
        return Login();
      return Home();
    },
  );
}
}