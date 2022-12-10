import 'package:flutter/material.dart';
import 'package:proyecto/routes/routes.dart';
import 'package:proyecto/widgets/materiasPrimas/materia_inicio.dart';
import 'package:proyecto/widgets/productos/producto_inicio.dart';
import 'package:proyecto/widgets/proveedores/proveedor_inicio.dart';
import 'package:proyecto/widgets/usuarios/usuario_inicio.dart';
import 'package:proyecto/widgets/mermas/merma_inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.INICIO: (context) => const MyHomePage(title: 'La Burguer'),
        Routes.usuario: (context) => const UsuariosInicio(),
        Routes.materiaPrima: (context) => const MateriasPrimasInicio(),
        Routes.proveedor: (context) => const ProveedoresInicio(),
        Routes.merma: (context) => const MermasInicio(),
        Routes.producto: (context) => const ProductosInicio()
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'La Burguer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
          /* Center(
        child: Container(
            padding: const EdgeInsets.all(15),
            child: const Image(
              image: NetworkImage(
                  'https://pbs.twimg.com/media/FjhZp_TUUAAXBql?format=png&name=medium'),
            )),
      ),
      drawer: */
          Drawer(
        // Agrega un ListView al drawer. Esto asegura que el usuario pueda desplazarse
        // a través de las opciones en el Drawer si no hay suficiente espacio vertical
        // para adaptarse a todo.
        child: ListView(
          // Importante: elimina cualquier padding del ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                padding: const EdgeInsets.all(15),
                // child: const Image(
                //image: NetworkImage(
                // 'https://pbs.twimg.com/media/FjhZp_TUUAAXBql?format=png&name=medium'),
                // )
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Row(
                children: [Icon(Icons.account_circle), Text("  Usuarios")],
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.usuario);
              },
            ),
            ListTile(
              title: Row(
                children: [Icon(Icons.add_business), Text("  Materias Primas")],
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.materiaPrima);
              },
            ),
            ListTile(
              title: Row(
                children: [Icon(Icons.airport_shuttle), Text("  Proveedor")],
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.proveedor);
              },
            ),
            ListTile(
              title: Row(
                children: [Icon(Icons.delete_sweep), Text("  Merma")],
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.merma);
              },
            ),
            ListTile(
              title: Row(
                children: [Icon(Icons.fastfood), Text("  Productos")],
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.producto);
              },
            ),
          ],
        ),
      ),
    );
  }
}
