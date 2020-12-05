import 'package:app_seu_bolso/auth.dart';
import 'package:app_seu_bolso/common/appColors.dart';
import 'package:app_seu_bolso/common/appSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  final ref = FirebaseStorage.instance;

  Widget _buildSalvarField(){
    return RaisedButton(
      child: Text(
        'Salvar',
      style: TextStyle(
        color: Colors.blue,
        fontSize: AppSize.fonts['md']
        ),
      ),
      onPressed: () {
        

      },
    );
  }

  
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppSize.edges['xl']),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  child:Image.asset('lib/assets/sbsplash.png'),
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,150, 0, 0),
                  child: RaisedButton(
                    onPressed: () async {
                      bool res = await AuthProvider().loginWithGoogle();
                    },
                    textColor: Colors.white,
                    color: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                              colors: <Color>[
                                AppColors.tertiaryColor,
                                AppColors.secondaryColor,
                                AppColors.primaryColor,
                              ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        child: Text("Login with Google"),
                    ),
                  )
                ),
              ],
            ),
          )
        ),
    );
  }
}
