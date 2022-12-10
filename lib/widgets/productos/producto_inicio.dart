import 'package:flutter/material.dart';
import 'package:proyecto/api/productosAPI.dart';
import 'package:proyecto/models/productos.dart';
import 'package:proyecto/widgets/productos/elementoProducto.dart';
import 'package:proyecto/widgets/productos/formularioProductos.dart';

class ProductosInicio extends StatefulWidget {
  const ProductosInicio({Key? key}) : super(key: key);

  @override
  State<ProductosInicio> createState() => _ProductosInicioState();
}

class _ProductosInicioState extends State<ProductosInicio> {
  late Future<List<Productos>> productos;
  late Future<List<Productos>> productosFiltrados;
  bool buscando = false;
  final TextEditingController _textoABuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerProductos();
  }

  obtenerProductos() {
    productos = ProductosAPI().getList();
    productosFiltrados = productos.then((value) => value);
  }

  List<Widget> _listaProductos(List<Productos> data) {
    List<Widget> usuarios = [];

    for (var producto in data) {
      usuarios.add(ElementoProducto(
          idProducto: producto.idProducto,
          strNombre: producto.strNombre,
          fltPrecio: producto.fltPrecio,
          strDescripcion: producto.strDescripcion,
          formulario: _formularioProductos));
    }

    return usuarios;
  }

  buscar() {
    if (_textoABuscar.text.length != 0) {
      productosFiltrados = productos.then((value) {
        String aux = _textoABuscar.text.toLowerCase();
        List<Productos> auxUsuarios = [];
        for (var element in value) {
          if (element.strNombre.toLowerCase() == aux ||
              element.fltPrecio == aux.toString() ||
              element.strDescripcion.toString() == aux) {
            auxUsuarios.add(element);
          }
        }
        return auxUsuarios;
      });

      buscando = true;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Ingrese el dato a buscar",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.amberAccent[300],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))));
    }
  }

  limpiar() {
    productosFiltrados = productos;
    _textoABuscar.text = "";
    buscando = false;
    setState(() {});
  }

  Future<void> _formularioProductos(int idProducto, String strNombre,
      double fltPrecio, String strDescripcion) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioProductos(
              idProducto: idProducto,
              strNombre: strNombre,
              fltPrecio: fltPrecio,
              strDescripcion: strDescripcion);
        }).then((value) {
      setState(() {
        obtenerProductos();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Añadir nuevo registro',
            onPressed: () => _formularioProductos(0, "", 0.0, ""),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: TextFormField(
                          controller: _textoABuscar,
                          decoration: const InputDecoration(
                            label: Text("Buscar"),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onPressed: () => buscar(),
                        ))
                  ],
                ),
                const Text(""),
                Visibility(
                  visible: buscando,
                  child: ElevatedButton(
                      onPressed: () => limpiar(),
                      child: const Text("Limpiar Busqueda")),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: productosFiltrados,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        children:
                            _listaProductos(snapshot.data as List<Productos>),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text("No hay registros");
                    }
                    return const CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
