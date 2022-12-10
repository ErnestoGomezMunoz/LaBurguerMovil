import 'package:flutter/material.dart';
import 'package:proyecto/api/productosAPI.dart';
import 'package:proyecto/widgets/productos/formularioProductos.dart';
import 'package:proyecto/widgets/validacionCambio.dart';
import 'package:proyecto/routes/routes.dart';

class ElementoProducto extends StatefulWidget {
  final int idProducto;
  final String strNombre;
  final double fltPrecio;
  final String strDescripcion;
  final Function formulario;
  const ElementoProducto(
      {Key? key,
      required this.idProducto,
      required this.strNombre,
      required this.fltPrecio,
      required this.strDescripcion,
      required this.formulario})
      : super(key: key);

  @override
  State<ElementoProducto> createState() => _ElementoProductoState();
}

class _ElementoProductoState extends State<ElementoProducto> {
  Future<void> _formularioProducto() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormularioProductos(
            idProducto: widget.idProducto,
            strNombre: widget.strNombre,
            fltPrecio: widget.fltPrecio,
            strDescripcion: widget.strDescripcion,
          );
        });
  }

  Future<void> _validarCambio(Function accion) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ValidacionCambio(
            titulo: "Guardar cambios", accion: accion, modulo: "Producto");
      },
    );
  }

  eliminar() {
    ProductosAPI().eliminar(widget.idProducto).then((res) {
      if (res == "OK") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Se ha eliminado un Producto",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
        Navigator.pushNamed(context, Routes.producto);
      } else if (res == "ERROR") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Ha ocurrido un error al eliminar un Producto",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
        Navigator.pushNamed(context, Routes.producto);
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
                "${widget.strNombre}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Precio: ${widget.fltPrecio}"),
              Text("Descripcion: ${widget.strDescripcion}"),
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
                        widget.idProducto,
                        widget.strNombre,
                        widget.fltPrecio,
                        widget.strDescripcion,
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
