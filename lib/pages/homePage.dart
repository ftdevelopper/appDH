import 'package:app_dos_hermanos/pages/shippingPage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> _riceType = ['Doble Carolina', 'Integral', 'Largo Fino', 'No se pasa', 'Aromatico', 'Yamani'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dos Hermanos',style:TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _riceType.length,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Envio numero: $index'),
                    subtitle: Text(_riceType[index]),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingPage(index: index)));
                    },
                  ),
                  Divider(),
                ],
              ),
              onDismissed: (direction){
                setState(() {
                  _riceType.removeAt(index);
                });
              },
            );
          },
        ),
      ),
    );
  }
}