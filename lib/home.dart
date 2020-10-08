import 'package:app_seu_bolso/common/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.docs.length > 0){
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('Form', arguments: snapshot.data.docs[index]);
                        },
                        leading: CircleAvatar(
                          backgroundColor: AppColors.backGroud,
                          child: Text("${index + 1}")
                        ),
                        title: Text(snapshot.data.docs[index].data()['titulo'].toString()),
                      ),
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
            return CircularProgressIndicator();
          },
        )
      );
  }

  Future<QuerySnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("metas").get();
  }

}