import 'package:flutter/material.dart';
import 'package:proyecto/api/proveedoresAPI.dart';
import 'package:proyecto/widgets/proveedores/formularioProveedores.dart';
import 'package:proyecto/widgets/validacionCambio.dart';

class ElementoProveedor extends StatefulWidget {
  final int idProveedor;
  final String strNombre;
  final String strDireccion;
  final int intCodigoPostal;
  final String strCiudad;
  final String strRFC;
  final String strTelefono;
  final int intEstatus;
  final Function formulario;
  const ElementoProveedor(
      {Key? key,
      required this.idProveedor,
      required this.strNombre,
      required this.strDireccion,
      required this.intCodigoPostal,
      required this.strCiudad,
      required this.strRFC,
      required this.strTelefono,
      required this.intEstatus,
      required this.formulario})
      : super(key: key);

  @override
  State<ElementoProveedor> createState() => _ElementoProveedorState();
}

class _ElementoProveedorState extends State<ElementoProveedor> {
  late int intEstatus;
  Future<void> _formularioProveedor() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioProveedores(
            idProveedor: widget.idProveedor,
            strNombre: widget.strNombre,
            strDireccion: widget.strDireccion,
            intCodigoPostal: widget.intCodigoPostal,
            strCiudad: widget.strCiudad,
            strRFC: widget.strRFC,
            strTelefono: widget.strTelefono,
            intEstatus: widget.intEstatus,
          );
        });
  }

  Future<void> _validarCambio(Function accion) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ValidacionCambio(
            titulo: "Guardar cambios", accion: accion, modulo: "Proveedor");
      },
    );
  }

  eliminar() {
    ProveedoresAPI().eliminar(widget.idProveedor).then((res) {
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
    ProveedoresAPI().activar(widget.idProveedor).then((res) {
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
                "${widget.strNombre}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Dirección: ${widget.strDireccion}"),
              Text("Código Postal: ${widget.intCodigoPostal}"),
              Text("Ciudad: ${widget.strCiudad}"),
              Text("RFC: ${widget.strRFC}"),
              Text("Teléfono: ${widget.strTelefono}"),
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
                      widget.idProveedor,
                      widget.strNombre,
                      widget.strDireccion,
                      widget.intCodigoPostal,
                      widget.strCiudad,
                      widget.strRFC,
                      widget.strTelefono,
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
