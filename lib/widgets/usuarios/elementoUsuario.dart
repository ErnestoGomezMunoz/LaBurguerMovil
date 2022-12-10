import 'package:flutter/material.dart';
import 'package:proyecto/api/usuariosAPI.dart';
import 'package:proyecto/widgets/usuarios/formularioUsuarios.dart';
import 'package:proyecto/widgets/validacionCambio.dart';

class ElementoUsuario extends StatefulWidget {
  final int intUsuarioId;
  final int intRolId;
  final String strNombre;
  final String strApellidoPaterno;
  final String strApellidoMaterno;
  final String strTelefono;
  final String strEmail;
  final String strPassword;
  final int intEstatus;
  final Function formulario;
  const ElementoUsuario(
      {Key? key,
      required this.intUsuarioId,
      required this.intRolId,
      required this.strNombre,
      required this.strApellidoPaterno,
      required this.strApellidoMaterno,
      required this.strTelefono,
      required this.strEmail,
      required this.strPassword,
      required this.intEstatus,
      required this.formulario})
      : super(key: key);

  @override
  State<ElementoUsuario> createState() => _ElementoUsuarioState();
}

class _ElementoUsuarioState extends State<ElementoUsuario> {
  late int intEstatus;
  late int intRolId;
  Future<void> _formularioUsuario() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioUsuarios(
            intUsuarioId: widget.intUsuarioId,
            intRolId: widget.intRolId,
            strNombre: widget.strNombre,
            strApellidoPaterno: widget.strApellidoPaterno,
            strApellidoMaterno: widget.strApellidoMaterno,
            strTelefono: widget.strTelefono,
            strEmail: widget.strEmail,
            strPassword: widget.strPassword,
            estatus: widget.intEstatus,
          );
        });
  }

  Future<void> _validarCambio(Function accion) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ValidacionCambio(
            titulo: "Guardar cambios", accion: accion, modulo: "Usuario");
      },
    );
  }

  eliminar() {
    UsuariosAPI().eliminar(widget.intUsuarioId).then((res) {
      if (res == "OK") {
        setState(() {
          intEstatus = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Se ha eliminado un usuario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
      } else if (res == "ERROR") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Ha ocurrido un error al eliminar un usuario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
      }
    });
  }

  activar() {
    UsuariosAPI().activar(widget.intUsuarioId).then((res) {
      if (res == "OK") {
        setState(() {
          intEstatus = 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Se ha activado un usuario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
      } else if (res == "ERROR") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Ha ocurrido un error al activar un usuario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
      }
    });
  }

  hacerCambio() {
    if (intEstatus == 0) {
      _validarCambio(activar);
    } else if (intEstatus == 1) {
      _validarCambio(eliminar);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intEstatus = widget.intEstatus;
    intRolId = widget.intRolId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(
            1.0,
            1.0,
          ),
          blurRadius: 1.0,
          spreadRadius: 1.0,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.strNombre} ${widget.strApellidoPaterno} ${widget.strApellidoMaterno}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              intRolId == 1
                  ? const Text("Rol: Administrador")
                  : intRolId == 2
                      ? const Text("Rol: Empleado")
                      : const Text("Rol: Cliente"),
              Text("Teléfono: ${widget.strTelefono}"),
              Text("Email: ${widget.strEmail}"),
              intEstatus == 0
                  ? const Text("Estatus: Inactivo")
                  : const Text("Estatus: Activo"),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () => hacerCambio(),
                  icon: intEstatus == 0
                      ? const Icon(
                          Icons.check_box_outline_blank_rounded,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )),
              IconButton(
                  onPressed: () => widget.formulario(
                      widget.intUsuarioId,
                      widget.intRolId,
                      widget.strNombre,
                      widget.strApellidoPaterno,
                      widget.strApellidoMaterno,
                      widget.strTelefono,
                      widget.strEmail,
                      widget.strPassword,
                      widget.intEstatus),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.deepOrangeAccent,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
