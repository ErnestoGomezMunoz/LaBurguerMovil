import 'package:flutter/material.dart';
import 'package:proyecto/api/materiasPrimasAPI.dart';
import 'package:proyecto/widgets/materiasPrimas/formularioMateriasPrimas.dart';
import 'package:proyecto/widgets/validacionCambio.dart';
import 'package:proyecto/routes/routes.dart';

class ElementoMateriaPrima extends StatefulWidget {
  final int idMateriasPrimas;
  final String strNombre;
  final int intCantidad;
  final int intCantidadXHamburguesa;
  final String strUnidad;
  final Function formulario;
  const ElementoMateriaPrima(
      {Key? key,
      required this.idMateriasPrimas,
      required this.strNombre,
      required this.intCantidad,
      required this.intCantidadXHamburguesa,
      required this.strUnidad,
      required this.formulario})
      : super(key: key);

  @override
  State<ElementoMateriaPrima> createState() => _ElementoMateriaPrimaState();
}

class _ElementoMateriaPrimaState extends State<ElementoMateriaPrima> {
  Future<void> _formularioMateriaPrima() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioMateriasPrimas(
            idMateriasPrimas: widget.idMateriasPrimas,
            strNombre: widget.strNombre,
            intCantidad: widget.intCantidad,
            intCantidadXHamburguesa: widget.intCantidadXHamburguesa,
            strUnidad: widget.strUnidad,
          );
        });
  }

  Future<void> _validarCambio(Function accion) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ValidacionCambio(
            titulo: "Guardar cambios", accion: accion, modulo: "MateriaPrima");
      },
    );
  }

  eliminar() {
    MateriasPrimasAPI().eliminar(widget.idMateriasPrimas).then((res) {
      if (res == "OK") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Se ha eliminado una Materia Prima",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
        Navigator.pushNamed(context, Routes.materiaPrima);
      } else if (res == "ERROR") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                "Ha ocurrido un error al eliminar una Materia Prima",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
        Navigator.pushNamed(context, Routes.materiaPrima);
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
                "Id: ${widget.idMateriasPrimas}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Nombre: ${widget.strNombre}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Cantidad: ${widget.intCantidad}"),
              Text("En Hamburguesa: ${widget.intCantidadXHamburguesa}"),
              Text("Unidad: ${widget.strUnidad}"),
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
              IconButton(
                  onPressed: () => widget.formulario(
                        widget.idMateriasPrimas,
                        widget.strNombre,
                        widget.intCantidad,
                        widget.intCantidadXHamburguesa,
                        widget.strUnidad,
                      ),
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
