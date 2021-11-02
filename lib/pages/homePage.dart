import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> _riceType = ['Blanco', 'Integral', 'Yamani', 'Bomba', 'Rojo', 'Salvaje'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dos Hermanos',style:TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
              key: Key('key'),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete),
              ),
              child: ListTile(
                title: Text('Envio numero: $index'),
                subtitle: Text(_riceType[index]),
                onTap: (){
                  
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index){
            return Divider();
          },
        ),
      ),
    );
  }
}