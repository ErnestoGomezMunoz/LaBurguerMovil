import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:proyecto/api/productosAPI.dart';
import 'package:proyecto/models/productos.dart';

class FormularioProductos extends StatefulWidget {
  final int idProducto;
  final String strNombre;
  final double fltPrecio;
  final String strDescripcion;

  const FormularioProductos(
      {Key? key,
      required this.idProducto,
      required this.strNombre,
      required this.fltPrecio,
      required this.strDescripcion})
      : super(key: key);

  @override
  State<FormularioProductos> createState() =>
      _FormularioProductosState();
}

class _FormularioProductosState extends State<FormularioProductos> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _strNombre = TextEditingController();
  final TextEditingController _fltPrecio = TextEditingController();
  final TextEditingController _strDescripcion = TextEditingController();

  guardar() {
    if (_form.currentState!.validate()) {
      if (widget.idProducto != 0) {
        Productos productos = Productos(
            widget.idProducto,
            _strNombre.text,
           double.parse(_fltPrecio.text),
            _strDescripcion.text);

        ProductosAPI().editar(productos).then((res) {
          if (res == "OK") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Se ha actualizado un productos",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          } else if (res == "ERROR") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Ha ocurrido un error al actualizar un productos",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          }
        });
      } else {
        Productos productos = Productos(
            widget.idProducto,
            _strNombre.text,
            double.parse(_fltPrecio.text),
            _strDescripcion.text);

        ProductosAPI().agregar(productos).then((res) {
          if (res == "OK") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Se ha registrado un producto",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          } else if (res == "ERROR") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Ha ocurrido un error al registrar un producto",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _strNombre.text = widget.strNombre;
    _fltPrecio.text = widget.fltPrecio.toString();
    _strDescripcion.text = widget.strDescripcion;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SimpleDialog(
        title: const Text("Guardar Producto"),
        contentPadding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Nombre"),
            ),
            controller: _strNombre,
            validator: (value) {
              String dato = value.toString();

              if (dato == "") {
                return "Este campo es obligatorio";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Precio"),
            ),
            controller: _fltPrecio,
            keyboardType: TextInputType.number,
            validator: (value) {
              String dato = value.toString();
              if (dato.isEmpty) {
                return "Este campo es obligatorio";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Descripción"),
            ),
            controller: _strDescripcion,
            keyboardType: TextInputType.text,
            validator: (value) {
              String dato = value.toString();
              if (dato.isEmpty) {
                return "Este campo es obligatorio";
              }
            },
          ),
          
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
                /*child: const Icon(
                  Icons.keyboard_return_sharp,
                  color: Colors.white,
                  ),*/

                child: Column(children: const [
                  Icon(
                    Icons.keyboard_return_sharp,
                    color: Colors.white,
                  ),
                  Text("Cancelar")
                ]),
              ),
              ElevatedButton(
                //Container
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 18, 146, 101)),
                ),
                onPressed: () {
                  guardar();
                },

                child: Column(children: const [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  Text("Guardar")
                ]),

                //child: const Text("Guardar")
              )
            ],
          )
        ],
      ),
    );
  }
}
