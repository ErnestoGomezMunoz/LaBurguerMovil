import 'package:flutter/material.dart';
import 'package:proyecto/api/mermasAPI.dart';
import 'package:proyecto/models/merma.dart';

class FormularioMermas extends StatefulWidget {
  final int idMerma;
  final int intIdMateriaPrima;
  final String strNombre;
  final int intCantidad;
  final String strFecha;

  const FormularioMermas(
      {Key? key,
      required this.idMerma,
      required this.intIdMateriaPrima,
      required this.strNombre,
      required this.intCantidad,
      required this.strFecha})
      : super(key: key);

  @override
  State<FormularioMermas> createState() => _FormularioMermasState();
}

class _FormularioMermasState extends State<FormularioMermas> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _intIdMateriaPrima = TextEditingController();
  final TextEditingController _strNombre = TextEditingController();
  final TextEditingController _intCantidad = TextEditingController();
  final TextEditingController _strFecha = TextEditingController();

  guardar() {
    if (_form.currentState!.validate()) {
      Merma merma = Merma(widget.idMerma, int.parse(_intIdMateriaPrima.text),
          _strNombre.text, int.parse(_intCantidad.text), _strFecha.text);
      MermasAPI().agregar(merma).then((res) {
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

  @override
  void initState() {
    super.initState();
    _intIdMateriaPrima.text = widget.intIdMateriaPrima.toString();
    _strNombre.text = widget.strNombre;
    _intCantidad.text = widget.intCantidad.toString();
    _strFecha.text = widget.strFecha;
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
              label: Text("IdMateriaPrima"),
            ),
            controller: _intIdMateriaPrima,
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
