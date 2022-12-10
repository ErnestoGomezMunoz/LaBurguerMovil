import 'package:flutter/material.dart';

class ValidacionCambio extends StatelessWidget {
  final String titulo;
  final String modulo;
  final Function accion;

  const ValidacionCambio(
      {Key? key,
      required this.titulo,
      required this.accion,
      required this.modulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(child: Text(titulo)),
      contentPadding: const EdgeInsets.all(15),
      children: [
        Center(child: Text("¿Estas seguro de hacer cambios en un $modulo?")),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: Column(children: const [
                Icon(
                  Icons.keyboard_return_sharp,
                  color: Colors.white,
                ),
                Text("Cancelar")
              ]),
            ),
            ElevatedButton(
              //style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                accion();
                Navigator.pop(context);
              },
              child: Column(children: const [
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                Text("Aceptar")
              ]),
            )
          ],
        )
      ],
    );
  }
}
