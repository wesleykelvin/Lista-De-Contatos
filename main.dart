import 'package:flutter/hian.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ListaContato());
}

class ListaContato extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListaContatos(),
      ),
    );
  }
}

class FormularioContatos extends StatelessWidget {
  final TextEditingController _controladorCampoNome = TextEditingController();
  final TextEditingController _controladorCampoCelular = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Adicionar Contato'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNome,
              rotulo: 'Nome',
              icone: Icons.account_circle,
              dica: 'Leandro Davi',
            ),
            Editor(
              rotulo: 'Celular',
              icone: Icons.add_call,
              controlador: _controladorCampoCelular,
              dica: 'XXXX-XXXX',
            ),
            RaisedButton(
              onPressed: () {
                _criaContato(context);
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  void _criaContato(BuildContext context) {
    final String Nome = (_controladorCampoNome.text);
    final double Celular = double.tryParse(_controladorCampoCelular.text);

    if (Nome != null && Celular != null) {
      final contatoCriado = Transferencia(Celular, Nome);
      debugPrint('$contatoCriado');
      Navigator.pop(context, contatoCriado);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaContatos extends StatefulWidget {
  final List<Transferencia> _adicionados = List();

  @override
  State<StatefulWidget> createState() {
    return ListaContatosState();
  }
}

class ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0,
        centerTitle: true,
        title: Text('Contatos'),
      ),
      body: ListView.builder(
        itemCount: widget._adicionados.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._adicionados[indice];
          return ItemAdicionado(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future<Transferencia> future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioContatos();
          })); //MaterialPageRoute

          future.then((contatoAdicionado) {
            debugPrint('Chegou no then do Future');
            debugPrint('$contatoAdicionado');
            if (contatoAdicionado != null) {
              setState(() => widget._adicionados.add(contatoAdicionado));
            }
          });
        },
        child: Icon(Icons.add),
      ), //FloatingActionButton
    );
  }
}

class ItemAdicionado extends StatelessWidget {
  final Transferencia _adicionado;

  ItemAdicionado(this._adicionado);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this._adicionado.Nome.toString()),
        subtitle: Text(this._adicionado.Celular.toString()),
      ),
    );
  }
}

class Transferencia {
  final double Celular;
  final String Nome;

  Transferencia(this.Celular, this.Nome);

  @override
  String toString() {
    return 'Transferencia => Celular da Transferencia: $Celular, Nome: $Nome';
  }
}