import 'package:flutter/material.dart';
import 'package:proyecto/api/proveedoresAPI.dart';
import 'package:proyecto/models/proveedor.dart';
import 'package:proyecto/widgets/proveedores/elementoProveedor.dart';
import 'package:proyecto/widgets/proveedores/formularioProveedores.dart';

class ProveedoresInicio extends StatefulWidget {
  const ProveedoresInicio({Key? key}) : super(key: key);

  @override
  State<ProveedoresInicio> createState() => _ProveedoresInicioState();
}

class _ProveedoresInicioState extends State<ProveedoresInicio> {
  late Future<List<Proveedor>> proveedores;
  late Future<List<Proveedor>> proveedoresFiltrados;
  bool buscando = false;
  final TextEditingController _textoABuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerProveedores();
  }

  obtenerProveedores() {
    proveedores = ProveedoresAPI().getList();
    proveedoresFiltrados = proveedores.then((value) => value);
  }

  List<Widget> _listaProveedores(List<Proveedor> data) {
    List<Widget> proveedores = [];

    for (var proveedor in data) {
      proveedores.add(ElementoProveedor(
          idProveedor: proveedor.idProveedor,
          strNombre: proveedor.strNombre,
          strDireccion: proveedor.strDireccion,
          intCodigoPostal: proveedor.intCodigoPostal,
          strCiudad: proveedor.strCiudad,
          strRFC: proveedor.strRFC,
          strTelefono: proveedor.strTelefono,
          intEstatus: proveedor.intEstatus,
          formulario: _formularioProveedores));
    }

    return proveedores;
  }

  buscar() {
    if (_textoABuscar.text.length != 0) {
      proveedoresFiltrados = proveedores.then((value) {
        String aux = _textoABuscar.text.toLowerCase();
        List<Proveedor> auxProveedores = [];
        for (var element in value) {
          if (element.strNombre.toLowerCase() == aux ||
              element.strDireccion.toLowerCase() == aux ||
              element.intCodigoPostal.toString() == aux ||
              element.strTelefono.toLowerCase() == aux ||
              element.strCiudad.toLowerCase() == aux ||
              element.strRFC.toString() == aux ||
              element.intEstatus.toString() == aux) {
            auxProveedores.add(element);
          }
        }
        return auxProveedores;
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
    proveedoresFiltrados = proveedores;
    _textoABuscar.text = "";
    buscando = false;
    setState(() {});
  }

  Future<void> _formularioProveedores(
      int idProveedor,
      String strNombre,
      String strDireccion,
      int intCodigoPostal,
      String strCiudad,
      String strRFC,
      String strTelefono,
      int intEstatus) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioProveedores(
            idProveedor: idProveedor,
            strNombre: strNombre,
            strDireccion: strDireccion,
            intCodigoPostal: intCodigoPostal,
            strCiudad: strCiudad,
            strRFC: strRFC,
            strTelefono: strTelefono,
            intEstatus: intEstatus,
          );
        }).then((value) {
      setState(() {
        obtenerProveedores();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proveedores"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Añadir nuevo registro',
            onPressed: () =>
                _formularioProveedores(0, "", "", 0, "", "", "", 1),
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
                  future: proveedoresFiltrados,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        children:
                            _listaProveedores(snapshot.data as List<Proveedor>),
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
