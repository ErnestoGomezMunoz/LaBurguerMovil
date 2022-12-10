import 'package:flutter/material.dart';
import 'package:proyecto/api/usuariosAPI.dart';
import 'package:proyecto/models/usuario.dart';

class FormularioUsuarios extends StatefulWidget {
  final int intUsuarioId;
  final int intRolId;
  final String strNombre;
  final String strApellidoPaterno;
  final String strApellidoMaterno;
  final String strTelefono;
  final String strEmail;
  final String strPassword;
  final int estatus;

  const FormularioUsuarios({
    Key? key,
    required this.intUsuarioId,
    required this.intRolId,
    required this.strNombre,
    required this.strApellidoPaterno,
    required this.strApellidoMaterno,
    required this.strTelefono,
    required this.strEmail,
    required this.strPassword,
    required this.estatus,
  }) : super(key: key);

  @override
  State<FormularioUsuarios> createState() => _FormularioUsuariosState();
}

class _FormularioUsuariosState extends State<FormularioUsuarios> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _intRolId = TextEditingController();
  final TextEditingController _strNombre = TextEditingController();
  final TextEditingController _strApellidoPaterno = TextEditingController();
  final TextEditingController _strApellidoMaterno = TextEditingController();
  final TextEditingController _strTelefono = TextEditingController();
  final TextEditingController _strEmail = TextEditingController();
  final TextEditingController _strPassword = TextEditingController();
  final TextEditingController _estatus = TextEditingController();

  guardar() {
    if (_form.currentState!.validate()) {
      if (widget.intUsuarioId != 0) {
        Usuario usuario = Usuario(
            widget.intUsuarioId,
            int.parse(_intRolId.text),
            _strNombre.text,
            _strApellidoPaterno.text,
            _strApellidoMaterno.text,
            _strTelefono.text,
            _strEmail.text,
            _strPassword.text,
            1);

        UsuariosAPI().editar(usuario).then((res) {
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
        Usuario usuario = Usuario(
            widget.intUsuarioId,
            int.parse(_intRolId.text),
            _strNombre.text,
            _strApellidoPaterno.text,
            _strApellidoMaterno.text,
            _strTelefono.text,
            _strEmail.text,
            _strPassword.text,
            1);

        UsuariosAPI().agregar(usuario).then((res) {
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
    _intRolId.text = widget.intRolId.toString();
    _strNombre.text = widget.strNombre;
    _strApellidoPaterno.text = widget.strApellidoPaterno;
    _strApellidoMaterno.text = widget.strApellidoMaterno;
    _strTelefono.text = widget.strTelefono;
    _strEmail.text = widget.strEmail;
    _strPassword.text = widget.strPassword;
    _estatus.text = widget.estatus.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SimpleDialog(
        title: const Text("Guardar usuario"),
        contentPadding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Rol"),
            ),
            controller: _intRolId,
            keyboardType: TextInputType.number,
            validator: (value) {
              String dato = value.toString();

              if (dato == "") {
                return "Este campo es obligatorio";
              }
            },
          ),
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
              label: Text("Apellido Paterno"),
            ),
            controller: _strApellidoPaterno,
            keyboardType: TextInputType.text,
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
              label: Text("Apellido Materno"),
            ),
            controller: _strApellidoMaterno,
            keyboardType: TextInputType.text,
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
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Email"),
            ),
            controller: _strEmail,
            validator: (value) {
              String dato = value.toString();
              if (dato.isEmpty) {
                return "Este campo es obligatorio";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("Password"),
            ),
            controller: _strPassword,
            obscureText: true,
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
