import 'package:app_seu_bolso/common/appSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  static const routeName = 'Form';
  @override
  State<StatefulWidget> createState(){
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {

  String _documentId;
  String _titleName;
  String _investimentType;
  List<String> _investimentTypes = [];
  String _payimentType;
  List<String> _payimentTypes = [];
  String _investimentValue;
  String _paymentDate;
  String _remainingValue;
  String _discountPercentual;
  String _salary;
  String _percentual;
  bool _update = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  addDataToBd(){
    Firebase.initializeApp();
    String dbDate = _paymentDate.split('/')[2]+'-'+_paymentDate.split('/')[1]+'-'+_paymentDate.split('/')[0];
    DateTime parsedDate = DateTime.parse(dbDate);
    Timestamp paymentDateTimestamp = Timestamp.fromDate(parsedDate);
    Map<String,dynamic> objeto = {
      'titulo': _titleName,
      'tipoInvestimento': FirebaseFirestore.instance.collection('tipoPagamento').doc(_investimentType),
      'tipoPagamento': FirebaseFirestore.instance.collection('tipoPagamento').doc(_payimentType),
      'totalInvestir': double.parse(_investimentValue),
      'totalRestante': double.parse(_investimentValue),
      'vencimento': paymentDateTimestamp
    };
    if(!_update){
      FirebaseFirestore.instance.collection('metas').add(objeto).catchError((onError){
        print(onError);
      });
    } else {
      FirebaseFirestore.instance.collection('metas').doc(_documentId).update(objeto).catchError((onError){
        print(onError);
      });
    }
    Navigator.of(context).pushNamed('Home');
  }

  deleteMeta(){
    Firebase.initializeApp();
    FirebaseFirestore.instance.collection('metas').doc(_documentId).delete();
    Navigator.of(context).pushNamed('Home');
  }

  descontarMeta(){
    print(this._discountPercentual);
    if(this._discountPercentual != null && double.parse(_percentual) <= 100.00){
      Map<String, dynamic> objeto = {
        'totalRestante': double.parse(_remainingValue) - (double.parse(_salary) * (double.parse(_percentual) / 100.00) * (double.parse(this._discountPercentual)/100))
      };
      Firebase.initializeApp();
      FirebaseFirestore.instance.collection('metas').doc(_documentId).update(objeto).catchError((onError){
        print(onError);
      });
      Navigator.of(context).pushNamed('Home');
    }
  }
  
  Widget _buildTituloField() {
     return TextFormField(
      decoration: InputDecoration(
        labelText: 'Título'
      ),
      initialValue: _titleName,
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
      initialValue: _investimentValue,
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
      initialValue: _paymentDate,
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

  Widget _buildPercentualDescontoField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Percentual de Desconto'
      ),
      initialValue: this._discountPercentual,
      validator: (String value){
        if(value.isEmpty){
          return 'Percentual de desconto é obrigatório';
        }

        return null;
      },
      onSaved: (String value){
        this._discountPercentual = value;
      },
     );
  }

  Widget _buildCancelarField(){
    return RaisedButton(
      child: Text(
        'Cancelar',
      style: TextStyle(
        color: Colors.blue,
        fontSize: AppSize.fonts['md']
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

  Widget _buildDeleteField(){
    return Visibility(
      child: RaisedButton(
        child: Text(
          'Deletar',
        style: TextStyle(
          color: Colors.blue,
          fontSize: AppSize.fonts['md']
          ),
        ),
        onPressed: () {
          deleteMeta();

        },
      ),
      visible: _update? true : false,
    );
  } 

  Widget _buildDescontoField(context){
    return Visibility(
      child: RaisedButton(
        child: Text(
          'Desconto',
        style: TextStyle(
          color: Colors.blue,
          fontSize: AppSize.fonts['md']
          ),
        ),
        onPressed: () {
          _formKey.currentState.save();
          descontarMeta();
        },
      ),
      visible: _update? true : false,
    );
  } 

  @override
  void initState() {
    super.initState();

    getTipoInvestimento().then((value) => {
      setState(() {
        value.docs.asMap().forEach((key, value) {
          this._investimentTypes.add(value.id);
        });
      })
    });

    getTipoPagamento().then((value) => {
      setState(() {
        value.docs.asMap().forEach((key, value) {
          this._payimentTypes.add(value.id);
        });
      })
    });

    getSalary().then((value) => {
      setState(() {
        value.docs.asMap().forEach((key, value) {
          this._salary = value.data()['valor'];
          this._percentual = value.data()['percentual'];
        });
      })
    });

  }


  @override
  Widget build(BuildContext context) {
    
    final QueryDocumentSnapshot metas = ModalRoute.of(context).settings.arguments;
    if(metas != null){
      _update = true;
      _documentId = metas.id; 
      _titleName = metas.data()['titulo'];
      _investimentType = metas.data()['tipoInvestimento'].id;
      _payimentType = metas.data()['tipoPagamento'].id;
      _investimentValue= metas.data()['totalInvestir'].toString();
      _paymentDate = getVencimento(metas.data()['vencimento']);
      _remainingValue = metas.data()['totalRestante'].toString();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Meta")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(AppSize.edges['sm']),
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
                Row(
                  children: <Widget>[
                  Spacer(),
                  _buildCancelarField(),
                  Spacer(),
                  _buildSalvarField(),
                  Spacer(),
                  _buildDeleteField(),
                  Spacer(),
                  ]
                ),
                if (_update) const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                if (_update) Text("Restantes: " + _remainingValue.toString(),
                  style: TextStyle(fontSize: AppSize.fonts['md']),
                ),
                if (_update) _buildPercentualDescontoField(),
                if (_update) _buildDescontoField(context),
            
              ],
              )
            ),
          )
        )  
      ),
    );
  }

  String getVencimento(Timestamp stringTime){
    DateTime date = stringTime.toDate();
    return DateFormat('dd/MM/yyyy').format(date).toString();
  }

  Future<QuerySnapshot> getTipoPagamento() {
    Firebase.initializeApp();
    return FirebaseFirestore.instance
      .collection("tipoPagamento").get();
  }

  Future<QuerySnapshot> getTipoInvestimento() async {
    Firebase.initializeApp();
    return await FirebaseFirestore.instance
      .collection("tipoInvestimento").get();
  }

  Future<QuerySnapshot> getSalary() async {
    Firebase.initializeApp();
    return await FirebaseFirestore.instance
      .collection("salario").get();
  }


}