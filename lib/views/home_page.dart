import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:share/share.dart';
import 'package:web_service/services/via_cep_service.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String? _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            MaterialButton(
              child: Icon(Icons.share),
              onPressed: () {
                Share.share(_result!);
              },),
            _buildResultForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    if(cep.length==8 && cep.length!=0) {
      final resultCep = await ViaCepService.fetchCep(cep: cep);
      print(resultCep.localidade); // Exibindo somente a localidade no terminal

      setState(() {
        if(resultCep.toJson() == null) {
          _result = 'teste';
        }else {
          _result = resultCep.toJson();
        }
      });

      _searching(false);
    }else{
      Flushbar(
        title: 'Erro',
        messageText: Text('CEP Inv??lido'),
        backgroundColor: Colors.lightBlue,
        borderRadius: 8,
        duration: Duration(seconds: 2),
        reverseAnimationCurve: Curves.easeInOut,
        forwardAnimationCurve: Curves.bounceInOut,
      ).show(context);
    }
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(_result ?? ''),
    );
  }
  }

