import 'package:app_seu_bolso/common/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardModal extends StatefulWidget {
  @override
  _CardModalState createState() => _CardModalState();
}

class _CardModalState extends State<CardModal> {
  
  var metas;
    
  getMetas(){
    return FirebaseFirestore.instance
        .collection("metas")
        .doc("sHlbhkZvMkfVRnFhMQgn")
        .get();


    /*Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('metas');
    collectionReference.snapshots().listen((snapshot) {

      setState((){
        if(snapshot.docs != null){
          metas = snapshot.docs;
        } else {
          print(snapshot);
        }
      });

    });*/

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: getMetas(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Título")
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: <Widget> [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(metas[index]);
                        },
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          child: Text("${index + 1}")
                        ),
                        title: Text(metas[index].data['titulo'].toString()),
                      ),
                      Text("Restante ${metas[index].data['totalRestante'].toString()}")
                    ],
                  )
                );
              },
              itemCount: /*metas.documents.length*/ 1,
            ),
          ),
        );
      } else if (snapshot.connectionState == ConnectionState.none) {
        return Text("No data");
      }
      return CircularProgressIndicator();
    }
    );
  }
}
