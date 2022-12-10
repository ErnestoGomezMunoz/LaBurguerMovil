import 'package:flutter/material.dart';
import 'package:proyecto/api/mermasAPI.dart';
import 'package:proyecto/widgets/mermas/formularioMermas.dart';
import 'package:proyecto/widgets/validacionCambio.dart';
import 'package:proyecto/routes/routes.dart';

class ElementoMerma extends StatefulWidget {
  final int idMerma;
  final int intIdMateriaPrima;
  final String strNombre;
  final int intCantidad;
  final String strFecha;
  final Function formulario;
  const ElementoMerma(
      {Key? key,
      required this.idMerma,
      required this.intIdMateriaPrima,
      required this.strNombre,
      required this.intCantidad,
      required this.strFecha,
      required this.formulario})
      : super(key: key);

  @override
  State<ElementoMerma> createState() => _ElementoMermaState();
}

class _ElementoMermaState extends State<ElementoMerma> {
  Future<void> _formularioMerma() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioMermas(
            idMerma: widget.idMerma,
            intIdMateriaPrima: widget.intIdMateriaPrima,
            strNombre: widget.strNombre,
            intCantidad: widget.intCantidad,
            strFecha: widget.strFecha,
          );
        });
  }

  Future<void> _validarCambio(Function accion) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ValidacionCambio(
            titulo: "Guardar cambios", accion: accion, modulo: "Merma");
      },
    );
  }

  eliminar() {
    MermasAPI().eliminar(widget.idMerma).then((res) {
      if (res == "OK") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Se ha eliminado una Merma",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
        Navigator.pushNamed(context, Routes.merma);
      } else if (res == "ERROR") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                "Ha ocurrido un error al eliminar una Materia Prima",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
        Navigator.pushNamed(context, Routes.merma);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                "Nombre: ${widget.strNombre}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Cantidad: ${widget.intCantidad}"),
              Text("Fecha: ${widget.strFecha}"),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () => _validarCambio(eliminar),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.deepOrangeAccent,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
