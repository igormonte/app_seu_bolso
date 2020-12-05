import 'package:app_seu_bolso/common/appColors.dart';
import 'package:app_seu_bolso/common/appSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  static const routeName = 'Home';
  
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Metas"),
        ),
        drawer: new Drawer(
          child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Seu Bolso'),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage("lib/assets/seubolsodrawer.png"),
                     fit: BoxFit.cover)
                ),
              ),
              ListTile(
              title: Text('Home'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
              title: Text('Salario'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.of(context).pushNamed('Salary', arguments: true);
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.docs.length > 0){
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.fromLTRB(AppSize.edges['md'], AppSize.edges['md'], AppSize.edges['md'], AppSize.edges['sm']),
                      color: getColor(snapshot.data.docs[index].data()['totalRestante'], snapshot.data.docs[index].data()['totalInvestir']), 
                      child: Center(
                        child:Padding(
                          padding: const EdgeInsets.all(19),
                          child: Row (
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Icon(Icons.email, size: 40, color: Colors.white)
                              ),
                              Column (
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>
                                [ new GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed('Form', arguments: snapshot.data.docs[index]);
                                      },
                                      child: new Text(snapshot.data.docs[index].data()['titulo'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),),
                                    ),
                                  Row (
                                    children: <Widget>[
                                      Text(getCurrencyFormat(snapshot.data.docs[index].data()['totalRestante'].toDouble())+' restantes...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                    ]
                                  ),
                                  Text('Vencimento: '+getVencimento(snapshot.data.docs[index].data()['vencimento']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))
                                  //Text(.toString())
                                ]
                              )
                            ]
                          )
                        )
                      )
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                );
              } else {
                //return Seu bolso futou
              }
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return Center(
              child: CircularProgressIndicator()
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('Form');
          },
          child: Icon(Icons.navigation),
          backgroundColor: AppColors.primaryColor
        ),
      );
  }

  Color getColor (valor, baseValor) {
    if (valor/baseValor > 0.8){
      return AppColors.vExpensive;

    } else if (valor/baseValor > 0.5) {
      return AppColors.expensive;

    } else if (valor/baseValor > 0.3) {
      return AppColors.cheap;

    } else {
      return AppColors.cheapest;

    }

  }

  String getVencimento(Timestamp stringTime){
    DateTime date = stringTime.toDate();
    return DateFormat('dd/MM/yyyy').format(date).toString();
  }

  String getCurrencyFormat(double valor){
     NumberFormat formater = new NumberFormat("R\$ ###.0#", "pt_BR");
     return formater.format(valor).toString();
  }

  Future<QuerySnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("metas").get();
  }

}