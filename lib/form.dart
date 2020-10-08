import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  static const routeName = 'Form';
  @override
  State<StatefulWidget> createState(){
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {

  String _titleName;
  String _investimentType;
  List<String> _investimentTypes = ['Automóvel', 'Imóvel', 'Viagem', 'Curso', 'Outros' ];
  String _payimentType;
   List<String> _payimentTypes = ['À vista', 'À prazo'];
  String _investimentValue;
  String _paymentDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  addDataToBd(){
    var objeto = {
      'titulo': _titleName,
      'tipoInvestimento': _investimentType,
      'tipoPagamento': _payimentType,
      'valorTotalInvestimento': _investimentValue,
      'dataPagamento': _paymentDate
    };
  }
  
  Widget _buildTituloField() {
     return TextFormField(
      decoration: InputDecoration(
        labelText: 'Título'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Título é obrigatório.';
        }

        return null;
      },
      onSaved: (String value){
        _titleName = value;
      },
     );
  }

  Widget _buildInvestimentoField() {
     return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Text('Tipo de Investimento'),
      value: _investimentType,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          _investimentType = newValue;
        });
      },
      validator: (String value){
        if(value.isEmpty){          
          return 'Tipo de Investimento é obrigatório.';
        }

        return null;
      },
      items: _investimentTypes
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }
      ).toList(),     
    );
  }
  
  Widget _buildTipoPagamentoField() {
     return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Text('Tipo de Pagamento'),
      value: _payimentType,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          _payimentType = newValue;
        });
      },
      validator: (String value){
        if(value.isEmpty){          
          return 'Tipo de Pagamento é obrigatório.';
        }

        return null;
      },
      items: _payimentTypes
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }
      ).toList(),     
    );
  }
  
   Widget _buildTotalInvestimentoField() {
     return TextFormField(
      decoration: InputDecoration(
        labelText: 'Valor Total do Investimento'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Valor Total do Investimento é obrigatório';
        }

        return null;
      },
      onSaved: (String value){
        _investimentValue = value;
      },
     );
  }
  
   Widget _buildDataPagamentoField() {
     return TextFormField(
      decoration: InputDecoration(
        labelText: 'Data de Pagamento'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Data de Pagamento é obrigatória.';
        }

        return null;
      },
      onSaved: (String value){
        _paymentDate = value;
      },
     );
  }

  Widget _buildCancelarField(){
    return RaisedButton(
      child: Text(
        'Cancelar',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 16
        ),
      ),
      onPressed: () {
         Navigator.pop(context);
      },
    );
  }

  Widget _buildSalvarField(){
    return RaisedButton(
      child: Text(
        'Salvar',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 16
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
  void initState() {
    super.initState();
    
    getTipoPagamento().then((value) => value.docs.map((e) => print('passou aqui')));
    getTipoInvestimento().then((value) => value.docs.map((e) => print(e.reference.id)));

  }


  @override
  Widget build(BuildContext context) {
    
    final QueryDocumentSnapshot metas = ModalRoute.of(context).settings.arguments;
    print(metas.data()['titulo']);
    return Scaffold(
      appBar: AppBar(title: Text("Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topCenter,
          child:Form(
            key: _formKey,
            child: Column(
            children: <Widget>[
              _buildTituloField(),
              _buildInvestimentoField(),
              _buildTipoPagamentoField(),
              _buildTotalInvestimentoField(),
              _buildDataPagamentoField(),
              _buildCancelarField(),
              _buildSalvarField(),
            ],
            )
          ),
        )
      ),
    );
  }

  Future<QuerySnapshot> getTipoPagamento() async {
  await Firebase.initializeApp();
  return await FirebaseFirestore.instance
      .collection("tipoPagamento").get();
  }

  Future<QuerySnapshot> getTipoInvestimento() async {
  await Firebase.initializeApp();
  return await FirebaseFirestore.instance
      .collection("tipoInvestimento").get();
  }


}