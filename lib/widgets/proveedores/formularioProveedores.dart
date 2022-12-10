import 'package:flutter/material.dart';
import 'package:proyecto/api/proveedoresAPI.dart';
import 'package:proyecto/models/proveedor.dart';

class FormularioProveedores extends StatefulWidget {
  final int idProveedor;
  final String strNombre;
  final String strDireccion;
  final int intCodigoPostal;
  final String strCiudad;
  final String strRFC;
  final String strTelefono;
  final int intEstatus;

  const FormularioProveedores(
      {Key? key,
      required this.idProveedor,
      required this.strNombre,
      required this.strDireccion,
      required this.intCodigoPostal,
      required this.strCiudad,
      required this.strRFC,
      required this.strTelefono,
      required this.intEstatus})
      : super(key: key);

  @override
  State<FormularioProveedores> createState() => _FormularioProveedoresState();
}

class _FormularioProveedoresState extends State<FormularioProveedores> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _strNombre = TextEditingController();
  final TextEditingController _strDireccion = TextEditingController();
  final TextEditingController _intCodigoPostal = TextEditingController();
  final TextEditingController _strCiudad = TextEditingController();
  final TextEditingController _strRFC = TextEditingController();
  final TextEditingController _strTelefono = TextEditingController();
  final TextEditingController _intEstatus = TextEditingController();

  guardar() {
    if (_form.currentState!.validate()) {
      if (widget.idProveedor != 0) {
        Proveedor proveedor = Proveedor(
            widget.idProveedor,
            _strNombre.text,
            _strDireccion.text,
            int.parse(_intCodigoPostal.text),
            _strCiudad.text,
            _strRFC.text,
            _strTelefono.text,
            1);

        ProveedoresAPI().editar(proveedor).then((res) {
          if (res == "OK") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Se ha actualizado un usuario",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          } else if (res == "ERROR") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Ha ocurrido un error al actualizar un usuario",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          }
        });
      } else {
        Proveedor proveedor = Proveedor(
            widget.idProveedor,
            _strNombre.text,
            _strDireccion.text,
            int.parse(_intCodigoPostal.text),
            _strCiudad.text,
            _strRFC.text,
            _strTelefono.text,
            1);

        ProveedoresAPI().agregar(proveedor).then((res) {
          if (res == "OK") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Se ha registrado un usuario",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))));
            Navigator.pop(context);
          } else if (res == "ERROR") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Ha ocurrido un error al registrar un usuario",
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
    _strDireccion.text = widget.strDireccion;
    _intCodigoPostal.text = widget.intCodigoPostal.toString();
    _strCiudad.text = widget.strCiudad;
    _strRFC.text = widget.strRFC;
    _strTelefono.text = widget.strTelefono;
    _intEstatus.text = widget.intEstatus.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SimpleDialog(
        title: const Text("Guardar Proveedor"),
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
              label: Text("Direccion"),
            ),
            controller: _strDireccion,
            keyboardType: TextInputType.text,
            validator: (value) {
              String dato = value.toString();
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Código Postal"),
            ),
            controller: _intCodigoPostal,
            maxLength: 5,
            keyboardType: TextInputType.number,
            validator: (value) {
              String dato = value.toString();

              if (dato.contains(",") ||
                  dato.contains(".") ||
                  dato.contains("-")) {
                return "No es permitido ingresar , . -";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Ciudad"),
            ),
            controller: _strCiudad,
            keyboardType: TextInputType.text,
            validator: (value) {
              String dato = value.toString();
              if (dato.isEmpty) {
                return "Este campo es obligatorio";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("RFC"),
            ),
            controller: _strRFC,
            maxLength: 13,
            keyboardType: TextInputType.text,
            validator: (value) {
              String dato = value.toString();
              if (dato.isEmpty) {
                return "Este campo es obligatorio";
              }
              if (dato.length < 12) {
                return "El RFC debe ser de tener 12 o 13 digitos";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Telefono"),
            ),
            controller: _strTelefono,
            maxLength: 10,
            keyboardType: TextInputType.number,
            validator: (value) {
              String dato = value.toString();
              if (dato.isEmpty) {
                return "Este campo es obligatorio";
              }
              if (dato.length != 10) {
                return "El telefono debe ser de tener 10 digitos";
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
