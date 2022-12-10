import 'package:flutter/material.dart';
import 'package:proyecto/api/mermasAPI.dart';
import 'package:proyecto/models/merma.dart';
import 'package:proyecto/widgets/mermas/elementoMerma.dart';
import 'package:proyecto/widgets/mermas/formularioMermas.dart';

class MermasInicio extends StatefulWidget {
  const MermasInicio({Key? key}) : super(key: key);

  @override
  State<MermasInicio> createState() => _MermasInicioState();
}

class _MermasInicioState extends State<MermasInicio> {
  late Future<List<Merma>> mermas;
  late Future<List<Merma>> mermasFiltradas;
  bool buscando = false;
  final TextEditingController _textoABuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerMermas();
  }

  obtenerMermas() {
    mermas = MermasAPI().getList();
    mermasFiltradas = mermas.then((value) => value);
  }

  List<Widget> _listaMermas(List<Merma> data) {
    List<Widget> mermas = [];

    for (var merma in data) {
      mermas.add(ElementoMerma(
          idMerma: merma.idMerma,
          intIdMateriaPrima: merma.intIdMateriaPrima,
          strNombre: merma.strNombre,
          intCantidad: merma.intCantidad,
          strFecha: merma.strFecha,
          formulario: _formularioMermas));
    }

    return mermas;
  }

  buscar() {
    if (_textoABuscar.text.length != 0) {
      mermasFiltradas = mermas.then((value) {
        String aux = _textoABuscar.text.toLowerCase();
        List<Merma> auxMermas = [];
        for (var element in value) {
          if (element.strNombre.toLowerCase() == aux ||
              element.intCantidad.toString() == aux ||
              element.strFecha.toLowerCase() == aux) {
            auxMermas.add(element);
          }
        }
        return auxMermas;
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
    mermasFiltradas = mermas;
    _textoABuscar.text = "";
    buscando = false;
    setState(() {});
  }

  Future<void> _formularioMermas(int idMerma, int intIdMateriaPrima,
      String strNombre, int intCantidad, String strFecha) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioMermas(
            idMerma: idMerma,
            intIdMateriaPrima: intIdMateriaPrima,
            strNombre: strNombre,
            intCantidad: intCantidad,
            strFecha: strFecha,
          );
        }).then((value) {
      setState(() {
        obtenerMermas();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mermas"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Añadir nuevo registro',
            onPressed: () => _formularioMermas(0, 0, "", 0, ""),
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
                  future: mermasFiltradas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        children: _listaMermas(snapshot.data as List<Merma>),
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
