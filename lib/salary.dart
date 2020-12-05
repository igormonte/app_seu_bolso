import 'package:app_seu_bolso/common/appSize.dart';
import 'package:app_seu_bolso/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Salary extends StatefulWidget {
  static const routeName = 'Salary';
  @override
  State<StatefulWidget> createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _documentId;
  String _salaryValue;
  String _percentualValue;
  bool _firstAccess = false;

  addDataToBd(){
    Firebase.initializeApp();
    Map<String,dynamic> objeto = {
      'valor': _salaryValue,
      'percentual': _percentualValue
    };

    FirebaseFirestore.instance.collection('salario').doc('dados').update(objeto).catchError((onError){
      print(onError);
    });

    Navigator.of(context).pushNamed('Home');
  }

  Widget _buildSalarioField(initialValue) {
    _salaryValue = initialValue;

    return TextFormField(
    decoration: InputDecoration(
      labelText: 'Salário Médio'
    ),
    initialValue: _salaryValue,
    validator: (String value){
      if(value.isEmpty){
        return 'O informe do salário médio é obrigatório';
      }

      return null;
    },
    onSaved: (String value){
      _salaryValue = value;
    },
    );
  }

  Widget _buildPercentualField(initialValue) {
    _percentualValue = initialValue;
    
    return TextFormField(
    decoration: InputDecoration(
      labelText: 'Percentual de Investimento'
    ),
    initialValue: _percentualValue,
    validator: (String value){
      if(value.isEmpty){
        return 'informe o percentual do seu salário para investimento';
      }

      return null;
    },
    onSaved: (String value){
      _percentualValue = value;
    },
    );
  }

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
        if(! _formKey.currentState.validate()){
          return;
        }
        _formKey.currentState.save();
        addDataToBd();

      },
    );
  }

  @override
  Widget build(BuildContext context) {

      final bool salary = ModalRoute.of(context).settings.arguments;

      if(salary || _firstAccess) {

      return Scaffold(
        appBar: AppBar(title: Text("Salário")),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(AppSize.edges['sm']),
            child: Align(
              alignment: Alignment.topCenter,
              child: FutureBuilder(
                future: getSalary(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.docs.length > 0){
                      if (snapshot.data.docs[0].data() != null ){
                        return Form(
                          key: _formKey,
                          child: Column(
                          children: <Widget>[
                            _buildSalarioField(snapshot.data.docs[0].data()['valor']),
                            _buildPercentualField(snapshot.data.docs[0].data()['percentual']),
                            _buildSalvarField(),
                            ]
                          )
                        );
                      } 
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              )
            )
          )
        )
      );
    } else {
      return Home();
    }
  }

  Future<QuerySnapshot> getSalary() async {
    Firebase.initializeApp();
    return await FirebaseFirestore.instance
      .collection("salario").get();
  }

}