import 'package:flutter/material.dart';
import 'package:proyecto/api/materiasPrimasAPI.dart';
import 'package:proyecto/models/materiaPrima.dart';
import 'package:proyecto/widgets/materiasPrimas/elementoMateriaPrima.dart';
import 'package:proyecto/widgets/materiasPrimas/formularioMateriasPrimas.dart';

class MateriasPrimasInicio extends StatefulWidget {
  const MateriasPrimasInicio({Key? key}) : super(key: key);

  @override
  State<MateriasPrimasInicio> createState() => _MateriasPrimasInicioState();
}

class _MateriasPrimasInicioState extends State<MateriasPrimasInicio> {
  late Future<List<MateriaPrima>> materiasPrimas;
  late Future<List<MateriaPrima>> materiasPrimasFiltradas;
  bool buscando = false;
  final TextEditingController _textoABuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerMateriasPrimas();
  }

  obtenerMateriasPrimas() {
    materiasPrimas = MateriasPrimasAPI().getList();
    materiasPrimasFiltradas = materiasPrimas.then((value) => value);
  }

  List<Widget> _listaMateriasPrimas(List<MateriaPrima> data) {
    List<Widget> usuarios = [];

    for (var materiaPrima in data) {
      usuarios.add(ElementoMateriaPrima(
          idMateriasPrimas: materiaPrima.idMateriasPrimas,
          strNombre: materiaPrima.strNombre,
          intCantidad: materiaPrima.intCantidad,
          intCantidadXHamburguesa: materiaPrima.intCantidadXHamburguesa,
          strUnidad: materiaPrima.strUnidad,
          formulario: _formularioMateriasPrimas));
    }

    return usuarios;
  }

  buscar() {
    if (_textoABuscar.text.length != 0) {
      materiasPrimasFiltradas = materiasPrimas.then((value) {
        String aux = _textoABuscar.text.toLowerCase();
        List<MateriaPrima> auxUsuarios = [];
        for (var element in value) {
          if (element.strNombre.toLowerCase() == aux ||
              element.strUnidad.toLowerCase() == aux ||
              element.intCantidad.toString() == aux ||
              element.intCantidadXHamburguesa.toString() == aux) {
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
    materiasPrimasFiltradas = materiasPrimas;
    _textoABuscar.text = "";
    buscando = false;
    setState(() {});
  }

  Future<void> _formularioMateriasPrimas(int idMateriasPrimas, String strNombre,
      int intCantidad, int intCantidadXHamburguesa, String strUnidad) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioMateriasPrimas(
            idMateriasPrimas: idMateriasPrimas,
            strNombre: strNombre,
            intCantidad: intCantidad,
            intCantidadXHamburguesa: intCantidadXHamburguesa,
            strUnidad: strUnidad,
          );
        }).then((value) {
      setState(() {
        obtenerMateriasPrimas();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Materias Primas"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Añadir nuevo registro',
            onPressed: () => _formularioMateriasPrimas(0, "", 0, 0, ""),
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
                  future: materiasPrimasFiltradas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        children: _listaMateriasPrimas(
                            snapshot.data as List<MateriaPrima>),
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
