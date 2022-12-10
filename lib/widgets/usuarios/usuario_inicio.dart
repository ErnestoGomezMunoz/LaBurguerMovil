import 'package:flutter/material.dart';
import 'package:proyecto/api/usuariosAPI.dart';
import 'package:proyecto/models/usuario.dart';
import 'package:proyecto/widgets/usuarios/elementoUsuario.dart';
import 'package:proyecto/widgets/usuarios/formularioUsuarios.dart';

class UsuariosInicio extends StatefulWidget {
  const UsuariosInicio({Key? key}) : super(key: key);

  @override
  State<UsuariosInicio> createState() => _UsuariosInicioState();
}

class _UsuariosInicioState extends State<UsuariosInicio> {
  late Future<List<Usuario>> usuarios;
  late Future<List<Usuario>> usuariosFiltrados;
  bool buscando = false;
  final TextEditingController _textoABuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  obtenerUsuarios() {
    usuarios = UsuariosAPI().getList();
    usuariosFiltrados = usuarios.then((value) => value);
  }

  List<Widget> _listaUsuarios(List<Usuario> data) {
    List<Widget> usuarios = [];

    for (var usuario in data) {
      usuarios.add(ElementoUsuario(
          intUsuarioId: usuario.intUsuarioId,
          intRolId: usuario.intRolId,
          strNombre: usuario.strNombre,
          strApellidoPaterno: usuario.strApellidoPaterno,
          strApellidoMaterno: usuario.strApellidoMaterno,
          strTelefono: usuario.strTelefono,
          strEmail: usuario.strEmail,
          strPassword: usuario.strPassword,
          intEstatus: usuario.estatus,
          formulario: _formularioUsuarios));
    }

    return usuarios;
  }

  /*buscar1() {
    if (_textoABuscar.text.length != 0) {
      usuariosFiltrados = usuarios.then((value) {
        String aux = _textoABuscar.text.toLowerCase();
        List<Usuario> auxUsuarios = [];
        for (var element in value) {
          if (element.strNombre.toLowerCase() == aux) {
            auxUsuarios.add(element);
          }
        }
        return auxUsuarios;
      });
      buscando = true;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Ingrese el nombre del usuario a buscar",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))));
    }
  }*/

  buscar() {
    if (_textoABuscar.text.length != 0) {
      usuariosFiltrados = usuarios.then((value) {
        String aux = _textoABuscar.text.toLowerCase();
        List<Usuario> auxUsuarios = [];
        for (var element in value) {
          if (element.strNombre.toLowerCase() == aux ||
              element.strApellidoPaterno.toLowerCase() == aux ||
              element.strApellidoMaterno.toLowerCase() == aux ||
              element.strTelefono.toLowerCase() == aux ||
              element.strEmail.toLowerCase() == aux ||
              element.intRolId.toString() == aux ||
              element.estatus.toString() == aux) {
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
    usuariosFiltrados = usuarios;
    _textoABuscar.text = "";
    buscando = false;
    setState(() {});
  }

  Future<void> _formularioUsuarios(
      int intUsuarioId,
      int intRolId,
      String strNombre,
      String strApellidoPaterno,
      String strApellidoMaterno,
      String strTelefono,
      String strEmail,
      String strPassword,
      int estatus) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioUsuarios(
            intUsuarioId: intUsuarioId,
            intRolId: intRolId,
            strNombre: strNombre,
            strApellidoPaterno: strApellidoPaterno,
            strApellidoMaterno: strApellidoMaterno,
            strTelefono: strTelefono,
            strEmail: strEmail,
            strPassword: strPassword,
            estatus: estatus,
          );
        }).then((value) {
      setState(() {
        obtenerUsuarios();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Añadir nuevo registro',
            onPressed: () =>
                _formularioUsuarios(0, 0, "", "", "", "", "", "", 1),
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
                  future: usuariosFiltrados,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        children:
                            _listaUsuarios(snapshot.data as List<Usuario>),
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
