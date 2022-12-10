import 'package:flutter/material.dart';
import 'package:proyecto/api/materiasPrimasAPI.dart';
import 'package:proyecto/models/materiaPrima.dart';

class FormularioMateriasPrimas extends StatefulWidget {
  final int idMateriasPrimas;
  final String strNombre;
  final int intCantidad;
  final int intCantidadXHamburguesa;
  final String strUnidad;

  const FormularioMateriasPrimas(
      {Key? key,
      required this.idMateriasPrimas,
      required this.strNombre,
      required this.intCantidad,
      required this.intCantidadXHamburguesa,
      required this.strUnidad})
      : super(key: key);

  @override
  State<FormularioMateriasPrimas> createState() =>
      _FormularioMateriasPrimasState();
}

class _FormularioMateriasPrimasState extends State<FormularioMateriasPrimas> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _strNombre = TextEditingController();
  final TextEditingController _intCantidad = TextEditingController();
  final TextEditingController _intCantidadXHamburguesa =
      TextEditingController();
  final TextEditingController _strUnidad = TextEditingController();

  guardar() {
    if (_form.currentState!.validate()) {
      if (widget.idMateriasPrimas != 0) {
        MateriaPrima materiaPrima = MateriaPrima(
            widget.idMateriasPrimas,
            _strNombre.text,
            int.parse(_intCantidad.text),
            int.parse(_intCantidadXHamburguesa.text),
            _strUnidad.text);

        MateriasPrimasAPI().editar(materiaPrima).then((res) {
          if (res == "OK") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Se ha actualizado una materia prima",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          } else if (res == "ERROR") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Ha ocurrido un error al actualizar una materia prima",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          }
        });
      } else {
        MateriaPrima materiaPrima = MateriaPrima(
            widget.idMateriasPrimas,
            _strNombre.text,
            int.parse(_intCantidad.text),
            int.parse(_intCantidadXHamburguesa.text),
            _strUnidad.text);

        MateriasPrimasAPI().agregar(materiaPrima).then((res) {
          if (res == "OK") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Se ha registrado una materiaPrima",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          } else if (res == "ERROR") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Ha ocurrido un error al registrar una materiaPrima",
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
    _intCantidad.text = widget.intCantidad.toString();
    _intCantidadXHamburguesa.text = widget.intCantidadXHamburguesa.toString();
    _strUnidad.text = widget.strUnidad;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SimpleDialog(
        title: const Text("Guardar Materia Prima"),
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
              label: Text("Cantidad"),
            ),
            controller: _intCantidad,
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
              label: Text("Cantidad por Hamburguesa"),
            ),
            controller: _intCantidadXHamburguesa,
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
              label: Text("Unidad"),
            ),
            controller: _strUnidad,
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
